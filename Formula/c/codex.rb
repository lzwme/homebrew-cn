class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.27.0.tar.gz"
  sha256 "fec549429b88215c283326d4611a21d034f4d596576b620137d67d0d4772914d"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6caf253e46a98994a681b4d8cb7840b766f1ce626a87fa788e66c29b4ed3c58f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfd93b4ed713bda11855776c1619a83a101da7d630f6545b6b1182d07e0ff75c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "342529add23c9291b75431d1df55cbf4bb797572b2558cb01eb609c4ec88d6b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "822e7f433f6ea4e3e13b9f168e51ec0b71dfe29065d3b9c42e8e0555c1da4bf1"
    sha256 cellar: :any_skip_relocation, ventura:       "74cbbca8277258472e41221626b734c38693da4f3856ec9ea6186a0be00a6033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fe0d9318161d57adbc6a58c144b5f430b09eec197ef723347a11089b1e315d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a75160b1d5e35e401996fbc356bb84e6928e8ad34200c2895488c98d4de082ea"
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