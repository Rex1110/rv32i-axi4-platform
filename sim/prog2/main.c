int main(void){
	extern int mul1;
	extern int mul2;
	extern int _test_start;
	long long result;

   	result = (long long) mul1 * mul2;

    *(&_test_start) = result;
	*(&_test_start + 1) = result >> 32;

	return 0;
}