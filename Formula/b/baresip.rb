class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.21.0.tar.gz"
  sha256 "cdd4ee5b37e3a21b12848f1e14b7998cdb23c040e2057909b3e6725ba1799322"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "62f2d129030beb7631846626c92db82b3b8e10cfc30ac7e511ab921209146389"
    sha256 arm64_sonoma:  "cd1b4fe7a312e884d06c238bc53dd2bd879a9a482b3a9023a81a4448e8fe2f90"
    sha256 arm64_ventura: "6b801569d8192395f114c290ea15ac4139ff887dea98433013d6afb5fefd3741"
    sha256 sonoma:        "3fa34859aaaad0289467d9df77853d5a523e0a46f1f0953999fb0e55a9fc5c73"
    sha256 ventura:       "9276ea976185f9c3eb89c8c2cda7b2bba7f54da029767de08c177e0a71f79357"
    sha256 arm64_linux:   "5ee3ae30a1b17ae656f463ca25f233e8cad1cd0b65e5733a7101a41eb4d8e87d"
    sha256 x86_64_linux:  "6ee35c976f5d861bcee2fb80d3499f11c81727e3f4e91d28eb7ca06d25e8ef0f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"baresip", "-f", testpath".baresip", "-t", "5"
  end
end