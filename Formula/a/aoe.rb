class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "51b4ef7b037d10d3fc7e6c1fd864dd09a916ef072c570db727e00faa632ace8a"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f42a3640d2c92b547451b25853a8941fbd106bc2a86997d81633ddf57e174bb7"
    sha256 cellar: :any,                 arm64_sequoia: "e6a0765678c95c0e5451b884fe66a97f5034759a27b03b434a86366943cc115e"
    sha256 cellar: :any,                 arm64_sonoma:  "ac17a8ba94518bc42001278e30637c5e9033943a2089a3996a7ab7d00a656129"
    sha256 cellar: :any,                 sonoma:        "256f09ee51d72e6e826707d80d65c3f72ddf7b19e26756324bf1262c0b58eb9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6516727b4c7aeca5bd77d5e3032515a275a14c57c2ef87902fca89a145f33ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afd9cb5bbb1734fb64d2d0cbbfbc9cf4c8f3ac6a87fd80543be1880f2a7fbf42"
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