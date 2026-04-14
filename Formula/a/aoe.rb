class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "55bb99e79d438643795e841bcffec7bb5dc84639bdb62842db0e1ddd40e17951"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea36a7ecded69e787027a765ccb54130c3aa312e7071369a8fcb06fe3e04411e"
    sha256 cellar: :any,                 arm64_sequoia: "d11dd61f996be926c95e8bf2f221ea8ecef3849dd4ea73ebfdbf11ee84efd9db"
    sha256 cellar: :any,                 arm64_sonoma:  "d5c296ed8eaabca0eb203a7d3e418b885f0b6526f8a9eb260e5f471cb1584f75"
    sha256 cellar: :any,                 sonoma:        "59262c6dc235ae57a5f07d1b108753376a86bb7e740853570a3e56d00557f590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad0c40c059ef6159ee6e8bdd8093b5da97f97ed36a32cf846a53e2d6bf259231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e3e2b1d2ca32b048c1c535f838238ec598ad2774836149a68a3cc1918621a06"
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
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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