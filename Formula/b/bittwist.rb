class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%204.2/bittwist-macos-4.2.tar.gz"
  sha256 "ac32f83ea0dca2d4f31a2ea4e2c8896076ae9028d8b93696742e82e54d08d0bd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50f78a4469b4e19aae2b168908a5af179dcc1e45ad7a1b08a9ef9d82dba9b85d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "636c1586913fd9ee4abb3984c8148fd9ad560e2d5d547ccaa5e5bd67db34fc4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "939dfc450a5709430cd689014a7045cfd2c94dd7508df5e377948d8540a33edd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef7f1495d77b16681fea9f52013e54d4bbcc2501f3f8ab607729ef3e64845829"
    sha256 cellar: :any_skip_relocation, ventura:       "6fc9dbeb7381a8bd9bccbb71d83d3f4ee8d9fbfc13d5dfee9e87b97281a0fe7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1bda1cc623446f81a727ef686f96ccfd99a97b1db3a577e011bf3969fbab1e6"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"bittwist", "-help"
    system bin/"bittwiste", "-help"
  end
end