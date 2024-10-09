class Facad < Formula
  desc "Modern, colorful directory listing tool for the command-line"
  homepage "https:github.comyellow-footed-honeyguidefacad"
  url "https:github.comyellow-footed-honeyguidefacadarchiverefstagsv2.14.0.tar.gz"
  sha256 "b6e7a91cf7217265590a29e6e69537b8d70faec4ac13de7c1f9bcf9b021d935b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f93c80c1eae740000d0de21c737bd754d368cf52d2feb30092f93b763b7334a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11fa7b1a52e9d8c4561615028582a08dc38695bf0000db932c3bbf2e42f1b4a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f3f87988eeaec286cc8a6d5f46916608f8cdee30c60f807afbb469430916f42"
    sha256 cellar: :any_skip_relocation, sonoma:        "641566b66ab03e797246bd2738fb1b1763775d76970fa3b3dbcea59fc036bac3"
    sha256 cellar: :any_skip_relocation, ventura:       "f6221a30725a456c649fec0035e297f7e4ce698e0aefa452736ba3b2621f339c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d6d039874897df4c29030ba11a535d39b5a477d16da21daa4e821ea29cbb32"
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