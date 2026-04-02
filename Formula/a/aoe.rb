class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f6a9356f180dc43f17791045e2fee352b55d318466918d2634e51c94d627df32"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e406c66d2552e067554d4cdfcc708a94639ba7e9959c9135f9f6757451553b0"
    sha256 cellar: :any,                 arm64_sequoia: "d37fdb03153bd6355d9f11809829c59483ff90ac66b4eb1b26cd6b7dde11f8e3"
    sha256 cellar: :any,                 arm64_sonoma:  "6d75eb37a3bf6db19a388f1ea036ed7e455c0ad20208da59295faf2b05a9966c"
    sha256 cellar: :any,                 sonoma:        "7021b15778bc3d7f4014935c32d5c5cdca9aff5035a3462a4bc6e3d6093fa633"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a582a3431e922dddcb3cdc0d5c06a853fbf9602776118148cb1924759956e97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a47f56a960d35232ffdfc33c7c154a3144ee87dd8189bef249de1023ac162c07"
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