class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "c120760ca4c6e7a4aede550bfa4264394ea81c608e5b80b7447bfd16ddc9b218"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f661fc6c95c07e4587045f5d2aedaaed139432fcd86106e772deadd8b4d35ef"
    sha256 cellar: :any,                 arm64_sequoia: "ef8aebd018fdafba976bd971a0dd732f9bf94e6076fe13810cc69c2dcf067846"
    sha256 cellar: :any,                 arm64_sonoma:  "9f4abc0db77149d7a8d026c5bb4aa9f2182915337b47d11150f431238f0afe5b"
    sha256 cellar: :any,                 sonoma:        "575f144be71e64c0c3087f00c51ce5b88c586ca30735f63672a1859f258136ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7913db9381d0522dc42ef12b7c7146e1474e5c6f69b87b8735fe1e44f4303381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d602d77bc103480e4b13095c1b35995aebcf1cdc364fdd24b864cddc48c2244"
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
    generate_completions_from_executable(bin/"aoe", "completion")
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