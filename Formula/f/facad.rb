class Facad < Formula
  desc "Modern, colorful directory listing tool for the command-line"
  homepage "https:github.comyellow-footed-honeyguidefacad"
  url "https:github.comyellow-footed-honeyguidefacadarchiverefstagsv2.1.0.tar.gz"
  sha256 "53da76af9871c16e20920f4cb31c40a10cb16fce9e3719aee8d285ea2e07ec5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3926a4003a884cc951e6aa9e508559c48562af6ddecb409aba80c534eddfc36a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "954bae0abf57386d9eb6b0b6d4a0c56c47c32830c8011d12d9a9c5f0a5da1efb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b6420b2d62a336d9e10acc79c3520da64528a1534e6fda2131fb082d5a69895"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cc8f5c02656dbe61fd31a532a8dfe04829a2e655ea5887fcf574026e35b76c7"
    sha256 cellar: :any_skip_relocation, ventura:       "1fb48e40db1229d8e5a60bd30594273ea9d01b6957933601f30f23340c0aa8bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "635ba534207a91a9d7acd6df1ebb480545f075203bb1a7d4e8abbf1bb89444a4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "facad version #{version}", shell_output("#{bin}facad --version")

    Dir.mkdir("foobar")
    assert_match "📁 foobar", shell_output(bin"facad")
  end
end