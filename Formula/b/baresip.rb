class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.17.0.tar.gz"
  sha256 "2b61e30b748e0bfce4f7eb63a96bc1a250114265bb3b9afb1ae6b710e12d353b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "dff2d364234868ba9f9ad088b8c8126dce0f5be958a554e458db33f8de125151"
    sha256 arm64_sonoma:  "a42f4de0a5c4c0b7fa3199f5fe219431632670a2e21bfbf1361c78ca84617eac"
    sha256 arm64_ventura: "b40d179c28eef1fa31b7a6204812fd6db11ef10fad3552bc009b9b9373ff6cb3"
    sha256 sonoma:        "539ad02c6017bf0a7ee2782486eb9c9d7e31dfacb5bf62713e820893dc529a85"
    sha256 ventura:       "e49e7d86bbfb616d2e27213020d4b78dc23267d02b8c1049dc4d5de08f2e3c07"
    sha256 x86_64_linux:  "13ab832bc63ca9a62a874d9b0697a3bead0f81c8c6ab61f23cde62d345513425"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin"baresip", "-f", testpath".baresip", "-t", "5"
  end
end