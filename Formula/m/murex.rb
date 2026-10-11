class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghfast.top/https://github.com/lmorg/murex/archive/refs/tags/v7.3.1231.tar.gz"
  sha256 "318a283faf9de54ef5caec711cb26a38bbd22f243f5940dceebc8c7b5f80c791"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff257762e52e9ce6d9884ab8f461a5abaf43dca8ed0fbfd65630489c0ab57996"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff257762e52e9ce6d9884ab8f461a5abaf43dca8ed0fbfd65630489c0ab57996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff257762e52e9ce6d9884ab8f461a5abaf43dca8ed0fbfd65630489c0ab57996"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "be8a4b9c9840f626f37253f3fa6c12c9d1a2e6dec6e75668217dc8912da917e1"
    sha256 cellar: :any,                 x86_64_linux:      "a7ca0b3614ae11eca85012da4280de9bf67bc5d58b96da98568f7bd2e76338d3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}/murex -version")
  end
end