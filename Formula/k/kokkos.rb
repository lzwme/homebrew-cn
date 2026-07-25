class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://ghfast.top/https://github.com/kokkos/kokkos/releases/download/5.2.0/kokkos-5.2.0.tar.gz"
  sha256 "54993e0682d80b78939bbf260490f8cf31428bb883c0309961369997f15d94df"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3229099f696fe60d552685667f888bb48556943c2aa0b73ebeb5e1057753bda3"
    sha256 cellar: :any, arm64_sequoia: "372ddf3c2a090edcf061a0a2e458e1271125698d0ba3e93be0d791f3a3291462"
    sha256 cellar: :any, arm64_sonoma:  "baf4fa99fb1f9e1b59be436ddd498fbc79f1df767ab1ce8cd90979c5186556ff"
    sha256 cellar: :any, sonoma:        "2e61f2442482c35de242b13b0ec6c928d5fade09fc5ee3932ca74c697de449c8"
    sha256 cellar: :any, arm64_linux:   "7e8790440f4ae051eb72308a77c5a27e8024775437b8d602beb366245b842ade"
    sha256 cellar: :any, x86_64_linux:  "13da950b56091e117f582cc34580c133fbfc1e5e3003f11f4a98b3bb2bd4a0f1"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %W[
      -DKokkos_ENABLE_OPENMP=ON
      -DKokkos_ENABLE_TESTS=OFF
      -DKokkos_ENABLE_EXAMPLES=OFF
      -DKokkos_ENABLE_BENCHMARKS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove Homebrew shim references from installed files
    inreplace bin/"kokkos_launch_compiler", Superenv.shims_path, ""
    inreplace lib/"cmake/Kokkos/KokkosConfigCommon.cmake", Superenv.shims_path, ""
  end

  test do
    (testpath/"minimal.cpp").write <<~CPP
      #include <Kokkos_Core.hpp>
      int main() {
        Kokkos::initialize();
        Kokkos::finalize();
        return 0;
      }
    CPP

    # Platform-specific OpenMP linking flags
    extra_args = if OS.mac?
      %W[-Xpreprocessor -fopenmp -I#{formula_opt_include("libomp")} -L#{formula_opt_lib("libomp")} -lomp]
    else
      # Linux - use GCC's built-in OpenMP
      %w[-fopenmp]
    end

    system ENV.cxx, "minimal.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lkokkoscore", *extra_args, "-o", "test"
    system "./test"
  end
end