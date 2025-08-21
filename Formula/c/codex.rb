class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.23.0.tar.gz"
  sha256 "ae7f4879d34ee600457b7368cf17f2206414531a36f46e03fc37ef2d3d7a9722"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf259e95e14a1cc3f4f7bfb5e9cfbd1aa1ea5df7faba793a51e13b13a3a51ae9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d49dbd8123c45ec0af84d80b484c319ba22966685eb495b8322e5fa23401e001"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b27b6c17a297e715b258f3b5e8ed375255caef11c2e9d81bf5d2f334ab9233c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "090902d8c1ca04c0580cb737d49597ba6ddcdfc18b90a74638e73140c4249cf2"
    sha256 cellar: :any_skip_relocation, ventura:       "16a9c5e96e0180fd0a9530e4cf56841c65ea5364b310bbbd2b16af512043007d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0df811aa66dc69a145bcee2c038db3fb63eeffeaa506f16f02e468972d5b932e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2713f7ae69d9f8122c3c0f0c9c0f408c7e0601c7f05e65eb493103ddf7b45e7"
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