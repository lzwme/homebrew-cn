class Readpe < Formula
  desc "PE analysis toolkit"
  homepage "https:github.commentebinariareadpe"
  url "https:github.commentebinariareadpearchiverefstagsv0.83.tar.gz"
  sha256 "4f84d186f8f6ff1622a0e47e3edb30a5cff6f3fe901ab9906800b850c2da8bc3"
  license "GPL-2.0-or-later"
  head "https:github.commentebinariareadpe.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "d8de00dac05b1f8dbe223eb101e99f52e54540cbe564450499f52a12b03aa5d4"
    sha256 arm64_ventura:  "8b839fb51639910b07b9fdc844ee40b0454d9e17f094c3b4d4bc9558d0afda40"
    sha256 arm64_monterey: "32adaa8c68d3f48693b430ef6a7d45f4e4e946428b347e08ee3b4924c30bd1d0"
    sha256 sonoma:         "845d8c287478319afc0af74a09aec8dd768f344b1fa1130c71556de4b05ac5ac"
    sha256 ventura:        "46936d597a4422c8422180e39cd17010c223fcbdd7e91166a2074fc8172ce192"
    sha256 monterey:       "6c7678e81990a6a6e24d3c808cc517d2869f1abdb34723fd3bb31dda2f67a527"
    sha256 x86_64_linux:   "d50a21d5e69d4d3e505fec9e7e9c94420362b91321cc858792c58ead5b8c4167"
  end

  depends_on "openssl@3"

  resource "homebrew-testfile" do
    url "https:the.earth.li~sgtathamputty0.78w64putty.exe"
    sha256 "fc6f9dbdf4b9f8dd1f5f3a74cb6e55119d3fe2c9db52436e10ba07842e6c3d7c"
  end

  def install
    ENV.deparallelize
    inreplace "liblibpeMakefile", "-flat_namespace", ""
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource("homebrew-testfile").stage do
      assert_match(Bytes in last page:\s+120, shell_output("#{bin}readpe .putty.exe"))
    end
  end
end