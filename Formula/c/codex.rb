class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.7.0.tar.gz"
  sha256 "7fbaf0a051d3e4b3179fce8d414754532c7551ba10ca415daca7f67f19c37194"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96ca2b0980ad7f6c2eb0809acb3af93a5ba69f3ffe9a992e9eb2238779395869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0af166e61c6930778eb5bdd109eaf7a2a68fb72fe7631ea35249fe3a1f4d905c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04641e7bbfcf0615a818bd3c1cac728e6e05ed95b6252a49f1385094cbb498e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "32fcc1c51b8d34ce4441899e429b270e990a26ea03688c226948ada2b375297d"
    sha256 cellar: :any_skip_relocation, ventura:       "233d1cd8f6c799b2816d903475fe095e33c960775530caf7ad67854bb86232fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ca79952005172c18bf7bcb0603776a90d40853b0adbc7ae10d4dd0059a8d67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fada73398fbbbf4be6befbfd327b36ab72f9dac5b83bf7d70f7aea8d574f300"
  end

  depends_on "rust" => :build

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