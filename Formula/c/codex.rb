class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.14.0.tar.gz"
  sha256 "6b03181c51f7caa9b0668f47a82a07ec23eb811fcf099f23ab437a0aecf9f12a"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9887f1390045ea3c6fdc6225dccc8cb537b6105f41a8e7c720a6cbc974a20f1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef0da52dbbef2051b22f03fc4ec62e9fd3c9a56d97a7bc4568e47572f57e117"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7440d923321fd6a8a29fe4b614836c26396b45d332aafa5023aec50a5e1bc85"
    sha256 cellar: :any_skip_relocation, sonoma:        "47a4837dd5d3a8760a28ea3be63ae78a0dadd7c375973733d7fc734434bd415a"
    sha256 cellar: :any_skip_relocation, ventura:       "782ba0a14529c618c9617081e2a99566746106be37af2f1422ff37fd36060646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57a35300410c7cac12ca553a029b9761cbe9a6d024b5f8fe49be6ff7ee5ff4ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abd04fb3a6456e7b250eb05ae5e41b4b506049b2fd42cf3f198364f7ba0a46d4"
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