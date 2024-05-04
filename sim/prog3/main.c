int GCD (int data1, int data2) {
	data1 = data1 % data2;
	if (data1 == 0) 
		return data2;
	else 
		return GCD(data2, data1);
}

int main () {
	extern int div1;
	extern int div2;
	extern int _test_start;

	if (div1 < div2) {
		int temp = div1;
			div1 = div2;
			div2 = temp;
	}

	*(&_test_start) = GCD(div1, div2);
	
	return 0;
}