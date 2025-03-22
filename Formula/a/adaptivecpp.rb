class Adaptivecpp < Formula
  desc "SYCL and C++ standard parallelism for CPUs and GPUs"
  homepage "https:github.comAdaptiveCppAdaptiveCpp"
  url "https:github.comAdaptiveCppAdaptiveCpparchiverefstagsv24.10.0.tar.gz"
  sha256 "3bcd94eee41adea3ccc58390498ec9fd30e1548af5330a319be8ce3e034a6a0b"
  license "BSD-2-Clause"
  head "https:github.comAdaptiveCppAdaptiveCpp.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "6af7a60866ba36c0ba11868fc6e297770759edd2a27cc0a5b0b367710e86b6bb"
    sha256 arm64_sonoma:  "f9c9b8747b3683f0867fd1a5fa9003c79021eb0e348f4dff8151be1df7489edd"
    sha256 arm64_ventura: "6712a76c4d5506b9cd9c687bbc6e70897753b976597ee2f92461efe818261dab"
    sha256 sonoma:        "4d6a4b0814bf29cd7c1c42fe56f5c6fe35bbf92616c3aefd40f54f97069cfe9a"
    sha256 ventura:       "a3d0b58605759af86b67a17f88ffdf7bb34219f8ca45a6b4886e142ed8301a9c"
    sha256 arm64_linux:   "ba37452491530ad9be470ede52f2f0e8533a340bc16c0a2498386e27670ee97c"
    sha256 x86_64_linux:  "8fbf35c1a2f4dfec80ed3d99d03908d8fcfcf8ad85f8fb7c587414b9b1be5859"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "llvm"
  uses_from_macos "python"

  on_macos do
    depends_on "libomp"
  end

  def install
    libomp_root = Formula["libomp"].opt_prefix

    system "cmake", "-S", ".", "-B", "build", "-DOpenMP_ROOT=#{libomp_root}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    shim_references = [prefix"etcAdaptiveCppacpp-core.json"]
    inreplace shim_references, Superenv.shims_pathENV.cxx, ENV.cxx

    # we add -I#{libomp_root}include to default-omp-cxx-flags
    inreplace prefix"etcAdaptiveCppacpp-core.json",
      "\"default-omp-cxx-flags\" : \"", "\"default-omp-cxx-flags\" : \"-I#{libomp_root}include "
  end

  test do
    system bin"acpp", "--version"

    (testpath"hellosycl.cpp").write <<~C
      #include <syclsycl.hpp>
      int main(){
          sycl::queue q{};
      }
    C
    system bin"acpp", "hellosycl.cpp", "-o", "hello"
    system ".hello"
  end
end