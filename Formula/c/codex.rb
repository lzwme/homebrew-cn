class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.29.0.tar.gz"
  sha256 "512d4ebd7d63ac826c13bd197e425851b08778500bffbbc5a6b92930715897fb"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67858f9e4981646dcb716f0cfc7b58e52a18f158b426291b724beda2194fae2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46cda57d22731797d47bb6fd73e80b574d296b9f505ef7be097188432516bada"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e75467bb08cb0715cfd7292cee2b2a6890be5d27b5de71c1f6de36bd50cfc443"
    sha256 cellar: :any_skip_relocation, sonoma:        "37a6ede397ccd2e7b99570d31092ac4645cfc60ca82c7ad23588f224b7292031"
    sha256 cellar: :any_skip_relocation, ventura:       "031ecd0af683c8224f4ca5da5520aff1d285f5ba538af8186c29fb136f4db7e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89b849f3ecb4851be31ffa13f48e33de506afd0bc94ac5f55fc291a31f8f9b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "248426075ffa010d0e669edf46c948033f614652c95b79df59ad984b309666c5"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    if OS.linux?
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
      ENV["OPENSSL_NO_VENDOR"] = "1"
    end

    system "cargo", "install", "--bin", "codex", *std_cargo_args(path: "codex-rs/cli")
    generate_completions_from_executable(bin/"codex", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex --version")

    assert_equal "Reading prompt from stdin...\nNo prompt provided via stdin.\n",
pipe_output("#{bin}/codex exec 2>&1", "", 1)

    return unless OS.linux?

    assert_equal "hello\n", shell_output("#{bin}/codex debug landlock echo hello")
  end
end