class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "8781975e2ff1ee3939e078ba8aacd4e31a76360c9a6e962529e5f7dd96d8a15f"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8346d419bccae4d1f9dbdc193ca0d0f92961cfe16e42528f952021d0e14e1ecf"
    sha256 cellar: :any,                 arm64_sequoia: "320dad896a8ceff963c10d951e42186f936c0e4a5219f278d2d69433c8ffccd8"
    sha256 cellar: :any,                 arm64_sonoma:  "c3344dc1ef56b15c1d4a95e87a5bcb772d3a5790cc994640959e9be2497b4e02"
    sha256 cellar: :any,                 sonoma:        "d5d9fdd0b7111a813875b8190f0cdb1a12f53b52fc43fd547ca41eaa7e883392"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1c8e180abe0c5e1fda4a7727d307950837c6d0d73827bb4d26628e28d0415af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b066f0b02adbc4bdc486680f5be2dfd64139154b876df26838db84d18da86d0"
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