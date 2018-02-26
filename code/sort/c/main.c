#define SIZE (10)
#define INPUT_FILE ("random_numbers_test")
#define OUTPUT_FILE ("c_result_test")

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int cmpfunc(const void * a, const void * b)
{
  return (*(int*)a - *(int*)b);
}

int main()
{
	// Initializing the file pointer
	FILE *fs;

	char ch, buffer[32];
	int i = 0, arr[SIZE], j = 0;

	// Openning the file with file handler as fs
	fs = fopen(INPUT_FILE, "r");

	// Read the file unless the file encounters an EOF
  for(ch = fgetc(fs); ; ch = fgetc(fs)) {
		if(ch == ',') {
			// Converting the content of the buffer into an array position
			arr[j] = atoi(buffer);

			// Increamenting the array position
			j++;

			// Clearing the buffer, this function takes two
			// arguments, one is a character pointer and
			// the other one is the size of the character array
			bzero(buffer, 32);

			i = 0;
		}
		else if (ch != EOF) {
			buffer[i] = ch;
			i++;
		}
    else {
      arr[j] = atoi(buffer);
      j++;

      break;
    }
	}

  fclose(fs);

  qsort(arr, j, sizeof(int), cmpfunc);

  fs = fopen(OUTPUT_FILE, "w");

  for(i = 0; i < SIZE - 1; i++) {
    fprintf(fs, "%d,", arr[i]);
  }

  fprintf(fs, "%d", arr[i]);

  fclose(fs);

  return 0;
}
