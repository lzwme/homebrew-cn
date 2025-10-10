class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.46.0.tar.gz"
  sha256 "56c614c6588b0131ab72aa58e4402f2957a1ab6cc8036063379253e7f4c3b272"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc79fbf73533df7a59aa7d2483bce80b94216a044a26a482761e23a472426fce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "573cf88f4f4256eb75c41d3f1b80871107fde969d3ec53ac714f76b232ce1eff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec5ebfb59ed20f89305dd8449aabfcb11b8836587f8fe7cdc71711dae0dfa06"
    sha256 cellar: :any_skip_relocation, sonoma:        "bafa3704d01b4a172806901c8f364fb83f134c5d5fcd7ee49e61f56e23d942c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1678b4c17381eb658a087914f3f463df8b91c5f4d9d857e85c6dd51ff71194f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96a284aae6c17aa4292ccc9a810805696836dc0a32680df7bfe4acfa531834e6"
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