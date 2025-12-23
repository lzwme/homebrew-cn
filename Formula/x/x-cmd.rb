class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "753ef57840d3abe022551bcad2057b858068bf87f3e36126b54138b00b7c4ae5"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9edfe3eef1b2ef33cecd0a6aae03b1f68400c38fb2a8d3398520f06c0f8b0867"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9edfe3eef1b2ef33cecd0a6aae03b1f68400c38fb2a8d3398520f06c0f8b0867"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9edfe3eef1b2ef33cecd0a6aae03b1f68400c38fb2a8d3398520f06c0f8b0867"
    sha256 cellar: :any_skip_relocation, sonoma:        "13fc0940faca6d723a5617d5820ca428be5ae60a00043df15d0f5b6d41e9df37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f8ff82d162170b8e6e898ea7d100a29f49b14e6b9964c93b368157f7ff30495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f8ff82d162170b8e6e898ea7d100a29f49b14e6b9964c93b368157f7ff30495"
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