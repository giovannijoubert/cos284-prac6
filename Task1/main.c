#include <stdio.h>
#include <stdlib.h>

struct Trie {
	struct Trie *children[26];
	char isWord[26];
};

extern struct Trie *trieAlloc();
extern void trieInit(struct Trie *);

int main(int argc, char *argv[]) {
	struct Trie *a = trieAlloc();
	trieInit(a);
	
	for (int i = 0; i < 26; i++)
		if (a->children[i] != 0 || a->isWord[i] != 0) printf("fail");
	
	
	return 0;
}
