#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Trie {
	struct Trie *children[26];
	char isWord[26];
};

struct Location {
	char row, col, len, dir;
};

struct Board {
	char *letters;
	int width;
};

typedef struct Trie Trie;
typedef struct Location Location;
typedef struct Board Board;

extern struct Trie *trieAlloc();
extern void trieInit(struct Trie *);
extern void trieInsert(struct Trie *, char *word);
extern int trieContains(struct Trie *, char *word);

Trie *trieLoad(char *filename) {
	Trie *result = trieAlloc();
	trieInit(result);
	FILE *file = fopen(filename, "r");
	
	char line[32];
	while (fgets(line, 32, file)) {
		for (int i = 31; i >= 0; i--) {
			if (line[i] == '\n') {
				line[i] = 0;
				break;
			}
		}
		trieInsert(result, line);
	}
	
	fclose(file);
	return result;
}

/*
 *   Location Methods
 */

Location *locationCreate(char row, char col, char len, char dir) {
	Location *result = malloc(4);
	result->row = row;
	result->col = col;
	result->len = len;
	result->dir = dir;
	return result;
}

Location *locationCopy(Location *loc) {
	return locationCreate(loc->row, loc->col, loc->len, loc->dir);
}

void locationShift(Location *loc, int amount) {
	if (amount > loc->len) abort();
	
	switch (loc->dir) {
		case 'W': loc->row -= amount; break;
		case 'X': loc->row += amount; break;
		case 'A': loc->col -= amount; break;
		case 'D': loc->col += amount; break;
		
		case 'Q': loc->row -= amount; loc->col -= amount; break;
		case 'E': loc->row -= amount; loc->col += amount; break;
		case 'Z': loc->row += amount; loc->col -= amount; break;
		case 'C': loc->row += amount; loc->col += amount; break;
	}
	loc->len -= amount;
}

/*
 *   Board Methods
 */

Board *boardCreate() {
	Board *result = malloc(16);
	result->letters = 0;
	result->width = 0;
	return result;
}

Board *boardLoad(char *filename) {
	Board *result = boardCreate();
	FILE *file = fopen(filename, "r");
	
	int w = fgetc(file);
	result->width = w;
	fgetc(file);
	
	result->letters = malloc((size_t)(w * w + 1));
	for (int i = 0; i < w * w; i++) result->letters[i] = ' ';
	result->letters[w * w] = 0;
	
	char line[w + 2];
	int k = 0;
	while (fgets(line, w + 2, file)) {
		line[w] = 0;
		for (int j = 0; j < w; j++) result->letters[k + j] = line[j];
		k += w;
	}
	
	fclose(file);
	return result;	
}

void boardPrint(Board *board) {
	for (size_t i = 1; i <= strlen(board->letters); i++) {
		printf("%c ", board->letters[i - 1]);
		if (i % (size_t)board->width == 0) printf("\n");
	}
}

int boardIndex(Board *board, Location *loc) {
	return loc->row * board->width + loc->col;
}

int boardContainsWordInLocation(Board *board, Trie *trie, Location *loc) {
	char word[loc->len + 1];
	
	Location *final = locationCopy(loc);
	locationShift(final, final->len);
	if (final->row < 0 || final->row >= board->width) return 0;
	if (final->col < 0 || final->col >= board->width) return 0;
	free(final);
	
	Location *next = locationCopy(loc);
	for (int i = 0; i < loc->len; i++) {
		word[i] = board->letters[boardIndex(board, next)];
		locationShift(next, 1);
	}
	free(next);
	word[loc->len] = 0;
	
	int contained = trieContains(trie, word);
	
	return contained;
}

int numberOfWordsAtCoord(Board *board, Trie *trie, char row, char col) {
	char directions[9] = "QWEDCXZA\0";
	int result = 0;
	Location *loc = locationCreate(row, col, 0, 'Q');
	for (int i = 2; i < 32; i++) {
		loc->len = (char)i;
		for (char *c = &directions[0]; *c != 0; c++) {
			loc->dir = *c;
			result += boardContainsWordInLocation(board, trie, loc);
		}
	}
	return result;
}

int numberOfWordsInBoard(Board *board, Trie *trie) {
	int result = 0;
	for (char r = 0; r < board->width; r++) {
		for (char c = 0; c < board->width; c++) {
			result += numberOfWordsAtCoord(board, trie, r, c);
		}
	}
	return result;
}
	

int main(int argc, char *argv[]) {
	Trie *trie = trieLoad("sowpods.txt");
	Board *board = boardLoad("example.txt");
	
	// Outputs: 61
	printf("%i\n", numberOfWordsInBoard(board, trie));
	
	return 0;
}
