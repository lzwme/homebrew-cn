class Primecount < Formula
  desc "Fast prime counting function program and CC++ library"
  homepage "https:github.comkimwalischprimecount"
  url "https:github.comkimwalischprimecountarchiverefstagsv7.12.tar.gz"
  sha256 "b801aa95e434d1b7575e42cb9009286b5f94618a417888bb6bd3217ef2f1321c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9aaced4b3704bd85257350557901d31a1ac4cce70880f03809c067b03d89c187"
    sha256 cellar: :any,                 arm64_ventura:  "c2850456b08b1e48bae408cfb148c92355cb1aa5195f0340fcf152178d063d6b"
    sha256 cellar: :any,                 arm64_monterey: "bc89de058276e1e25d4512ee0e012060eb2a111e7b9af81256675509505e8700"
    sha256 cellar: :any,                 sonoma:         "b8d99d258bc190c9528a9ac666a046341b231bfd01fa0e43e77ba8b30daf3a9e"
    sha256 cellar: :any,                 ventura:        "3a2d435726332363510802b494db869f33813e7c8b3a563b46976d7fe2e66203"
    sha256 cellar: :any,                 monterey:       "154e85ec53aae8978eee2bbc360ad7badf2595f99921a069a12bf49a355103a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae3cffa82a4942929ac078e943d692c4b65627a45219a14e0050f86da91d0153"
  end

  depends_on "cmake" => :build
  depends_on "primesieve"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON",
                                              "-DBUILD_LIBPRIMESIEVE=OFF",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "37607912018\n", shell_output("#{bin}primecount 1e12")
  end
end