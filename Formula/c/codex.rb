class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.28.0.tar.gz"
  sha256 "b04df1161a256508fbee0eca90036ebd6b9867a406df0abfba0d19324da07c3c"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83d2b87dcd83fc6f459b9ccd7f3af38ae7eef81608db83228ca3c8b78582f83f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21b54c5eee675d2def86263078664b85835dd5c979b03c84df23c6abc00c8d4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a744d9d0ab9435823434c1ac47948faa9715b96b129d7e26e8e6afff3261bf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f17dd75eb989a59422dc00a5daa3ea509d53a6adee87f5e85f27df9495125dc0"
    sha256 cellar: :any_skip_relocation, ventura:       "5432b8bfac03791209d4106877a53629925a17153a60dbdcd52d8f5285f8dc58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac97982157fb6d24c7af1c844f4cb2581950dce9fba272036c3f21036dcf63f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd2233931847d2ea92fa56a5eb91ecb3b901b98f920fc6bcf523ad222059c7d9"
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