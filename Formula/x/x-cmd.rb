class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "aa8eea0e0564ecf1f00dcfc13fe6c63356539a81c1e8a4a8519efa67e4676530"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89522c15ea8706aa6e8559df4b4702e5b35946c4247f96b702deb0fe4df41f92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89522c15ea8706aa6e8559df4b4702e5b35946c4247f96b702deb0fe4df41f92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89522c15ea8706aa6e8559df4b4702e5b35946c4247f96b702deb0fe4df41f92"
    sha256 cellar: :any_skip_relocation, sonoma:        "1551f4c86addbcdaa16a7a7c5862b21b811f47174049b4950a4c5a49ffd02034"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "986317d856d753f40da7607cfdb8595c17a4f13ac14e2f45d4b7fb03463ba616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "986317d856d753f40da7607cfdb8595c17a4f13ac14e2f45d4b7fb03463ba616"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end