#include <stdio.h>
#include <stdlib.h>

#define	MAXN		4
#define	MAXMOVES	(1 << MAXN)

typedef	struct
{
	short	disk;
	short	from;
	short	to;
} move_t;
move_t 	movearray[MAXMOVES];	// for modelsim verification

void
move(int n, int from_rod, int to_rod)
{
	static unsigned	moves = 0;

    // printf("Move %u disk %d from %c to %c\n", moves, n, from_rod, to_rod);
	movearray[moves].disk = n;
	movearray[moves].from = from_rod;
	movearray[moves].to = to_rod;
	moves++;
}

void
hanoi(int n, char from_rod, char to_rod, char aux_rod)  
{  
    if (n == 1)  
    {  
        move(n, from_rod, to_rod);
		return;
    }  
    hanoi(n - 1, from_rod, aux_rod, to_rod);  
    move(n, from_rod, to_rod);
    hanoi(n - 1, aux_rod, to_rod, from_rod);  
}  
  
int 
main()  
{  
    int 		n = MAXN; // Number of disks  
	int			disk, from_rod, to_rod;
	int			i;
    hanoi(n, 'A', 'C', 'B'); // A, B and C are names of rods  
	for (i = 0; i < MAXMOVES - 1; i++)
	{
		disk = movearray[i].disk;
		from_rod = movearray[i].from;
		to_rod = movearray[i].to;
    	printf("Move %u disk %d from %c to %c\n", i, disk, from_rod, to_rod);
	}
    return 0;  
}  
