# Use of bitmaps to store boolean flags to save considerable amount of gas

In this above example of using bitmaps we are keeping track of rewards for which the member is
eligible. In a traditional way it can be handled using multiple boolean variables(flags) but we can save gas by using a single uint to store a bitmap of the boolean flags. The particular flag value can be obtained by bitwise operations.
