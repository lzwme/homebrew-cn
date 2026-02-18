class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "566096e651188b823366fede8cb7debbef5a38541eaaaed5c9e7bf6613676a5f"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a617e9f23df2c42b222a58cfbcb60b8b377654098be667e353bbc2550faa20a"
    sha256 cellar: :any,                 arm64_sequoia: "473179084285949afd47b91dcb999ebc50c2cd426324fc04d6bdc6021aa9546a"
    sha256 cellar: :any,                 arm64_sonoma:  "f0f8689645d60f2985061d71b1b867cd50177f1e203750e87b9c0de3a88949b6"
    sha256 cellar: :any,                 sonoma:        "1f98faf330ae823fc0089d898ec9b280bf6f94e653a0ad5cf179753ba53cb033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "344b3cb1a2e4a5e8dafbd43ea5ee1a5f46817582a2f52bd8434922414566e8cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "698ffaf3e44d0e70a0ca03e344aa55bb37f8d445bfae5aa2d141cada69b5640e"
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