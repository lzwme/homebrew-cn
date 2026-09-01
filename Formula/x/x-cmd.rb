class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "049f96ef6d182e880dc8d806e15a423e97fd71c038d77931696e06eb9290e14b"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9312e4382790131e5e5dab9a7ff8ab45a128d4e8b7b1316eed8295511fd91aba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9312e4382790131e5e5dab9a7ff8ab45a128d4e8b7b1316eed8295511fd91aba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9312e4382790131e5e5dab9a7ff8ab45a128d4e8b7b1316eed8295511fd91aba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "476491b56b950a4f9363f393f3840337849cf4c8dd4803d063afd17e1e655234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "476491b56b950a4f9363f393f3840337849cf4c8dd4803d063afd17e1e655234"
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