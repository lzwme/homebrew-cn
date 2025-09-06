class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.30.0.tar.gz"
  sha256 "50b99c605c784f831d84d46d6c766433349f33a91a0dbb209e0bfda168625b3f"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9da4d7d5b3214b20fec89770d14fa297d907c61181f15e5a11369b2e1d3a0bb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67aa00dc94a3be3efa8db84dd06b67dc6ba724d2eb7e51953728de7f7c9f65d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d547038a805f4e788ea5e5e101ab50fbe430d1187b0936004d766f0bbeef1c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2962916ed9daf470dc7919adf6bb88854c187356282105c7a5dc735cfdf987e"
    sha256 cellar: :any_skip_relocation, ventura:       "d7574a01f3844a967c4d3c5feb45534f8f13282507c47aa64a8c491ceffdc208"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31da45a7cd52db369cd864382e74eeecd1b24c108b9c2e9dd169aee9dc6c2baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b6378a234877dac2abd57f2f92a3affd543266e47e3c02bc97af1f5348c595"
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