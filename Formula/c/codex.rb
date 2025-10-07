class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.45.0.tar.gz"
  sha256 "e9bafcbb7030fb3a7ec9ab845e43d830e2e45e2eee19898d443fe03a414b419e"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a879a8d0b67507bf572df11d557d06464b85174c61e3aa4aa12114acdca251b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9917eaccb86d5875a2d6e57e15c0a2fdc0693dc245daa99a842b459b0b8e498c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de74e6341aae57a5a49bafa0391e8276df39ac39ca5f654f72c95c392b92b485"
    sha256 cellar: :any_skip_relocation, sonoma:        "2842e23c4ac6f7ebff5acbd37827b810b56274ad5cf8e32b90f43f7dbe6daf26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c03aef287372af6fb6e3cd78686574a83220ae6eb1d896c2e8a29b5b3d6c72a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37d1e5f40f79a7fbcea5b32fa1ed6613bdc3636db6fda5d7c41f7862e7d1ab49"
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