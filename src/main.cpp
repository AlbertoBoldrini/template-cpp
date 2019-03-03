#define SIMDPP_ARCH_X86_AVX

#include <iostream>
#include <chrono>
#include <header.hpp>
#include <simdpp/simd.h>

int main ()
{
    auto t1 = std::chrono::high_resolution_clock::now();
    auto t2 = std::chrono::high_resolution_clock::now();

    std::chrono::duration<double, std::micro> time = t2 - t1;

    simdpp::float64<SIMDPP_FAST_FLOAT64_SIZE> x = simdpp::make_float(1.,2.,3.,4.);
    simdpp::float64<SIMDPP_FAST_FLOAT64_SIZE> y = simdpp::make_float(1.,2.,3.,4.);



    auto z = (x + y).eval();




    std::cout << simdpp::extract<0>(z);

    
    return 0;
}