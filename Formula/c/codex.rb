class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.13.0.tar.gz"
  sha256 "302723718206d2a06c4b71905a547bbfc39c9b756e63a6def8cee5c98c1f1bbb"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad21257ae24cfd0cd1417f1f6b85e8276d29ecf4f0e329a98906339f9e3f71fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79b0579e1f25524ab5aad961b283157999a41bbed650f6ddd7be93f868a5c6d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a106a0f83456b7d4c12fb50339c6641e0e2d7977cccbce29ba33954028faa4f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b94f4622c027388907641a2ab4d0b305d325a17897b83b6b113a8fc0ba2f88c"
    sha256 cellar: :any_skip_relocation, ventura:       "0d377d3eb5ee639f224aef9c945c3649f6b2acddcd00f4d60bb013434889091b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "517c8f3da9c740e8f710fb2a2ba6c7266ac7affffa847c9eb052eaa1ccec21ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27a3bfe06aca99a7895702ad13f4ab55443cfad43d3af3b5ad9ed31a2a0231fa"
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