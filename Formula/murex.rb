class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/refs/tags/v4.1.3000.tar.gz"
  sha256 "19033c15bea2bdb9a45e07147efc07b3f6430f17880c76b752bf5734f0626f3a"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6c02295ce663c6bfcaf14929dc451b7a17d0e5cb0e56795334bc3f7772c4e0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "581a17ff7c94f5e9609807e63171e7045327a9d6309f23ee7cde26b56b0f0bab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29cf31ec10e3c81fdb2597c0d31b631dc925e947fcc5c3ec32bc227e1f3fda67"
    sha256 cellar: :any_skip_relocation, ventura:        "898c6fed8a2d6a776a02dc970019e2132eb82b23c12f547b2aff0df03054a67e"
    sha256 cellar: :any_skip_relocation, monterey:       "035e910475e9a63842260ed113f323393592a8b5b9a33c4acbfe6beb54d602b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c79d55d17799b0829767a4ca95a2f92085979e6ecaf079a99d791d998586531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb6af9510017dca1b5efa34fd9e10c34585483cb0f873e3edcd6db7ede103cba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end