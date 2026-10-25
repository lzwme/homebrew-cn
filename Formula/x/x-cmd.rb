class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.13.tar.gz"
  sha256 "7ac52d518a4424a6149cb15d14a322ce809575c210629068912cfba4942ee6c5"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c12a539e11540adb3b7d04d962db359ed129d70de8ff2c88459cdc7f492503e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c12a539e11540adb3b7d04d962db359ed129d70de8ff2c88459cdc7f492503e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c12a539e11540adb3b7d04d962db359ed129d70de8ff2c88459cdc7f492503e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f31616625d492334fc1c63f99abc62d81c966b239335bf3178a056d68acfd864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f31616625d492334fc1c63f99abc62d81c966b239335bf3178a056d68acfd864"
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