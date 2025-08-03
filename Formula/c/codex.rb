class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.11.0.tar.gz"
  sha256 "97f7b27622b55c78c13c2f5432e8c9acc713f3f8ee2970049c1353697a4e3630"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac5b5508bde96016d673914088040727e7581f4a75add04bda9281fc5610330b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb28dde985ac17fb7b557f9eac0f5d58482a502ed2dd5ce48a1487339f843d7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb5b7aeba371f6d09e48215f502e9a4aba530893b09ad9d66d197471e43add29"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aee78113fdaaf35898397105b91b0565963e4783b4bc0d3fe11a6962d913fa0"
    sha256 cellar: :any_skip_relocation, ventura:       "07f890db142f717d63834b66dda46dc1629cc4c3ed02bc1efde59a9e854cb43f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14a6ba195d0510cdc848fd1c50b18bb43de1afbd6a3f1f991c497d4d334c781b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0bec61fcd3cd81691a00953954b98dbb369f3ede9bed6edafde184af9f75a53"
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