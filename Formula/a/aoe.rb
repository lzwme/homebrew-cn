class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "f3179f625264f80ba86e46be6c7303717067430b3a144ac05cf7def726dc5098"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e888897f74b383711843a13d92314aa47594250cbf9c5f2960d693cbe5a4211"
    sha256 cellar: :any,                 arm64_sequoia: "82f3e748fd4a29eec9aad3668c4f933bb69883ed6a43bf54ce6395451e5c9066"
    sha256 cellar: :any,                 arm64_sonoma:  "a23adaed188cbeed9f0cfee104abb448fb7eb14b97ff893ab0db9f5f7cc488fc"
    sha256 cellar: :any,                 sonoma:        "40c8cec19e0c342b55b41704f1b08eed91f7e8ef5e9e9479faccec1d48ddac5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36606032ccbb43d3fb33260cc60b7c97edb297fa3574a95688592c2ffd7df40a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c9bd414d3c29780f9627312eaa27512a9592dcc0bee1de65cd62c599605447e"
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
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]
  end
end