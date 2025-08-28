class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.25.0.tar.gz"
  sha256 "0b0bc88747afc31820400b27ef74733be7ac73757ed3da4af8ac4e0d817a163c"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0ff5282fa413cbbb4a0918ca0c05d600a338feb6c77c0e1cb8aa6f378716ee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9ac79797984396ee27d05c415adeb380844b3a3bb05b20235b876d35764b5b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fa50f84aab29d9b2cbf8a069539e870367241df35dd2cb0c0acdf28f303cf49"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1b03c8fb7daabf95ee3acab0e1618adc596b5b720c3ec4f89d74bfb53da9bb7"
    sha256 cellar: :any_skip_relocation, ventura:       "6a6ba5a4fe386e6bfee0aeeefbc5fea69104a84a8ac502575b2d4c85d5ea7bed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3816c86b71f6f5b0a04b33aa1531fba7f6480ac82b23cc14d6298b8d0f7aacf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47a1c2ff0391c40cae8b2c61f7d9c96550984e2683b47a447cb7f231fbee0ecc"
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