class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https:github.comfreebsdlutok"
  url "https:github.comfreebsdlutokreleasesdownloadlutok-0.5lutok-0.5.tar.gz"
  sha256 "9cdc3cf08babec6e70a96a907d82f8b34eac866dd7196abc73b95d5e13701f55"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e32874f4a95cdd38f4391253fa9252b443d03fe0bdb8f628f4d118f8ecb5a69"
    sha256 cellar: :any,                 arm64_sonoma:  "154d00c3114fe64469ec54977d189c8f83815af51ef16c95406a0a7885067a09"
    sha256 cellar: :any,                 arm64_ventura: "8a9ab6d781bfb340295d4da2bad20ada63a90a9b9eb4a586eab1d0686d7db9fe"
    sha256 cellar: :any,                 sonoma:        "50ceaa40b7954932f72f101589f03bdf26cf16bfe9c9a3805fd1194d1ff1838f"
    sha256 cellar: :any,                 ventura:       "e4ba0f8494a46eab869c3443a07eb143fcb7e9715e0f5c44261e460c091bebf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82aa5ccf29fda46f215b71698a5e36533e5833e14de3d86c3d8d073810978b0c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "atf"
  depends_on "lua"

  # add configure.ac patch, upstream pr ref, https:github.comfreebsdlutokpull24
  patch do
    url "https:github.comfreebsdlutokcommitb2e45d2848f64e1178eb0c6ed44d0b8fc4ea5dea.patch?full_index=1"
    sha256 "0dbb00bd646343f3b8b61e07222e5ca21ae85028c84772b1eb5b0feba098b4b8"
  end

  def install
    system "glibtoolize", "--force", "--install"
    system "autoreconf", "--force", "--install", "--verbose"

    system ".configure", "--disable-silent-rules", "--enable-atf", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "check"
    system "make", "install"
    system "make", "installcheck"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <lutokstate.hpp>
      #include <iostream>
      int main() {
          lutok::state lua;
          lua.open_base();
          lua.load_string("print('Hello from Lua')");
          lua.pcall(0, 0, 0);
          return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs lutok").chomp.split
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test", *flags
    system ".test"
  end
end