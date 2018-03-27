#define SIZE (10)
#define INPUT_FILE ("random_numbers")
#define OUTPUT_FILE ("c_result")

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Just difference of two numbers
int cmpfunc(const void * a, const void * b)
{
  return (*(int*)a - *(int*)b);
}

int main()
{
	// Initializing the file pointer
	FILE *fs;

  // current char and buffer for digits
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

      // setting the buffer index to 0
			i = 0;
		}
		else if (ch != EOF) {
      // add the next character to the buffer
			buffer[i] = ch;
      // increment the buffer index
			i++;
		}
    else { // end of the file
      // add the number from the buffer to
      arr[j] = atoi(buffer);

      // end the loop
      break;
    }
	}

  // close the file
  fclose(fs);

  // sort the array
  qsort(arr, SIZE, sizeof(int), cmpfunc);

  // open the output file
  fs = fopen(OUTPUT_FILE, "w");

  // write every number (except the last one) with a comma after each
  for(i = 0; i < SIZE - 1; i++) {
    fprintf(fs, "%d,", arr[i]);
  }

  // write the last number
  fprintf(fs, "%d", arr[i]);

  // close the file
  fclose(fs);

  // return 0 (success code)
  return 0;
}
