class Libblastrampoline < Formula
  desc "Using PLT trampolines to provide a BLAS and LAPACK demuxing library"
  homepage "https://github.com/JuliaLinearAlgebra/libblastrampoline"
  url "https://ghfast.top/https://github.com/JuliaLinearAlgebra/libblastrampoline/archive/refs/tags/v5.15.0.tar.gz"
  sha256 "69e0be57ebf037c1997c35edf03565614cd3c6863a695d01348a21bf1f482e74"
  license all_of: [
    "MIT",
    "BSD-2-Clause-Views", # include/common/f77blas.h
    "BSD-3-Clause",       # include/common/lapacke*
  ]

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "90f6de35e38c114a4423470feee4c574c1d861737a6f2e8ad1267f3130077a93"
    sha256 cellar: :any, arm64_tahoe:       "7d8bd0dbe33b63006fbd5b14ac0a143622158ed89e56b109699c8e33899b2983"
    sha256 cellar: :any, arm64_sequoia:     "e682c144697c7ba4524a2e93f4e0596697ba0f671125ff0b84e3c395490d80a6"
    sha256 cellar: :any, arm64_linux:       "ca2d58d5ffd6d9e18bbfc9ae8e7d0bc2ab0b01ad7ba3779222fdef29546a9761"
    sha256 cellar: :any, x86_64_linux:      "a8d8a6da9a5366f30696cac341e8049d7461045e47d8b526f0de668f7aef1808"
  end

  depends_on "openblas64" => :test

  def install
    system "make", "-C", "src", "install", "prefix=#{prefix}"
    (pkgshare/"test").install "test/dgemm_test/dgemm_test.c"
  end

  test do
    cp pkgshare/"test/dgemm_test.c", testpath

    (testpath/"api_test.c").write <<~C
      #include <assert.h>
      #include <stdio.h>
      #include <libblastrampoline.h>

      int main() {
        const lbt_config_t * config = lbt_get_config();
        assert(config != NULL);

        lbt_library_info_t ** libs = config->loaded_libs;
        assert(libs != NULL);
        assert(sizeof(libs) == sizeof(lbt_library_info_t *));
        assert(libs[0] != NULL);

        printf("%s", libs[0]->libname);
        return 0;
      }
    C

    system ENV.cc, "dgemm_test.c", "-I#{include}", "-L#{lib}", "-lblastrampoline", "-o", "dgemm_test"
    system ENV.cc, "api_test.c", "-I#{include}", "-L#{lib}", "-lblastrampoline", "-o", "api_test"

    # Full path as `shell_output` runs via SIP-protected `/bin/sh` which strips `DYLD_*`
    test_libs = [(formula_opt_lib("openblas64")/shared_library("libopenblas64_")).to_s]
    test_libs << "/System/Library/Frameworks/Accelerate.framework/Accelerate" if OS.mac?

    test_libs.each do |test_lib|
      with_env(LBT_DEFAULT_LIBS: test_lib) do
        assert_equal test_lib, shell_output("./api_test")
        system "./dgemm_test"
      end
    end
  end
end