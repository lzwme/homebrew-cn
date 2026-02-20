class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "b38b61f8cc220859b58d57e6025eca11f63b4e4c6736a1f8737df1825b01f418"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d68f62ce09b3502604f96f73b30870d2c3522cd63c9a8aaecf6c55949ffe9960"
    sha256 cellar: :any,                 arm64_sequoia: "115523b5b54cdeafe3b093586c014d70232451bda72e28d937522df92b17629e"
    sha256 cellar: :any,                 arm64_sonoma:  "d51bb79fa5790832ca79ad5c010f68e84f3fc3a5388562ee4227c938ccb9cab4"
    sha256 cellar: :any,                 sonoma:        "98c4eb9ec553b3a804a2475a4e80cffe48f53a6ed016350c9b2745ef6bb1c4c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3d8de02af5fa9798e26f17cd75c853912f0a9b7ced398a4334de561a5aefa18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f422a12541c94f6a65770d6fd3b5be8f23c2260b50a31c304a27796e4d11ca0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".aoe/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]
  end
end