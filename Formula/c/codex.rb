class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.21.0.tar.gz"
  sha256 "6361cbfc661552aaa84f8bb4c1477ed4c59892855e0273e991af1d01dc71fc47"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb2c075729951eecaf5342440289ef4a7d53e91c088eec8a1c22f0a34de5c74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48836b7f0ca57e5e0e1aeaac06f5015aa4b6cd0cb604dce0c7890b910c74554d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d883d6fff183d13492860c833a96bad903361bb09784710b3e95371f990d38d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e301eb43516bfdf9e1f1d3741444df81bab0ed33783c89ec92558918a1966780"
    sha256 cellar: :any_skip_relocation, ventura:       "06c736c4a87ba7723f90aa4936b8738ab148c090347b4114eb5236f0cee37714"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d63fcbc6aca1f762ed46db47b57476f1e58daa01053ccac2a2ef23e8b6fe2056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fca0ace6edfb0ba8ad6c3f76c0f24f5329697a5c422948015872ed4ab57218b3"
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