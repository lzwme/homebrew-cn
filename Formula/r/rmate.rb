class Rmate < Formula
  desc "Edit files from an SSH session in TextMate"
  homepage "https:github.comtextmatermate"
  url "https:github.comtextmatermatearchiverefstagsv1.5.8.tar.gz"
  sha256 "40be07ae251bfa47b408eb56395dd2385d8e9ea220a19efd5145593cd8cbd89c"
  license "MIT"
  head "https:github.comtextmatermate.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fb6dd771050399730a0a7592fe0a135705a294b10fd02263bd6cfcbc284cee2a"
  end

  uses_from_macos "ruby"

  def install
    bin.install "binrmate"
  end

  test do
    system bin"rmate", "--version"
  end
end