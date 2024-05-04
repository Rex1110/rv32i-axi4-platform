int main (void) {
	extern	int	array_size;
	extern	int	array_addr;
	extern	int	_test_start;

	int temp, point;
	*(&_test_start) = *(&array_addr);
	for (int count = 1; count < array_size; ++count) {
		*(&_test_start+count) = *(&array_addr+count);
		temp = *(&_test_start+count);
		point = count;
		while ((point >0) && (*(&_test_start+point-1) > temp)) {
			*(&_test_start+point) = *(&_test_start+point-1);
			*(&_test_start+point-1) = temp;
			--point;
		}
	}
	return 0;
}
