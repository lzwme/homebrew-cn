class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/refs/tags/v4.1.4200.tar.gz"
  sha256 "d2a795c56b27bac43d1f66aa0b7fc80ea64583eb57f7249ddb4a4982ab7fd452"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d3ca089e07a9b18a07c77fea563c9cb13d320edb5c3d6431f4fcfbc5bef835c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71431382ff9b503be6094a34e70987a4d3c677f0fc1c0e45547cea979bed03e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a622ec38437596d1bb95fcea327cdabec60bb17f2fdc830395691fcdf067f7d8"
    sha256 cellar: :any_skip_relocation, ventura:        "5ddb50c6d42bc0e0d1d213a17808fa36e9223f0ee87c39172ff2f4d0fda07264"
    sha256 cellar: :any_skip_relocation, monterey:       "ab49299e861a47621822f96b8e9966174b5616651c59206c6e584273b2b4ef7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "904a846ef36bae0b7c9086575d14fa246b6af2549653e133a782cf47bd0a9952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee8010c42f0a09f2ed2152f9f681aad400b22afe3d71118fccdb20f772c95f7f"
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