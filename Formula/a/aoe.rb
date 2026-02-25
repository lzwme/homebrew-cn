class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "e0c663b6881a28f82ebdec0b6198878c052cf0644c6e1c8cc97d354782f2c05e"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee2973d29a15fba22317beedd3a627b27a86a655903a94091f33036206679688"
    sha256 cellar: :any,                 arm64_sequoia: "ba7543956d920e287002b516dff020cca7cbec09932bc12309fcefdff7eff206"
    sha256 cellar: :any,                 arm64_sonoma:  "99af4ae6a9ce0b70c9f7b2c1eca126ea93b15040e54b476f8da13ace10b955f6"
    sha256 cellar: :any,                 sonoma:        "5fc7d05b9faa0e530338f95269edb5864ccc0f4bc0e06010c7c49f93a1ec4b5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5f9ff2bbea3ac82662d86b1819b16262fde43b2e8530da8523c30f2926501f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42439c8567519cb2055fecde2d7bc790dc8c47fa29e8b392e8352e98b63a7846"
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