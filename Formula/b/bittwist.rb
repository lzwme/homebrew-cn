class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%204.6/bittwist-macos-4.6.tar.gz"
  sha256 "368b44a742f280aea18bb9f4243ae1cb702206e84cebe471bb7d43a06f149c4e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59b96ef3a7f8f69ddacc9272c6c371e085742634f1247fa2849493be4e3d271d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20811fc83e2eb40017655bf3945c45d7723d15a705954a211969ef95d6424763"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74937ffc1f5fa930ad223185a79d59348393a8ea550ea27f79a8937ef21f2eeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ce3cd677adf86442ddee6a396addc9df981e45d40e4f7c1ae5440b466824e48"
    sha256 cellar: :any_skip_relocation, ventura:       "65b67c083b0805579885c06b7f2f8ce5797900c8655948aaa0341927877f64a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2cfb1f3a035d5c5fa9eab924f66f0c64d207b4fe0487359af757110cad2f402"
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