class Roundup < Formula
  desc "Unit testing tool"
  homepage "https:bmizerany.github.ioroundup"
  url "https:github.combmizeranyrounduparchiverefstagsv0.0.6.tar.gz"
  sha256 "20741043ed5be7cbc54b1e9a7c7de122a0dacced77052e90e4ff08e41736f01c"
  license "MIT"
  head "https:github.combmizeranyroundup.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8e7150a458867eba0d53eae749b908b7bb9f8f2d8838471025e4570aee54e846"
  end

  def install
    system ".configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "SHELL=binbash"
    system "make", "install"
  end

  test do
    system bin"roundup", "-v"
  end
end