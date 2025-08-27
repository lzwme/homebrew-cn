class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.24.0.tar.gz"
  sha256 "3c9342a967e1bcf6729cc2195c52c93192f3010cd1c6756d1d699bb6dda38b22"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb4be4998b655f10800910d9153b28fc876ae1fc1edee57f6424b5e9a015b541"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "576a47a8f95b4c301ed7f937cdd72a866333b76235845f79de87b248b2473ba5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "134ef5d080bc0a46896655faf6357256ceff75c40d8dc2f88f75a8530e10b7ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "28fbe5147abebe647e4f54f13f601339139eb0cbb7b32408022509ecca736e31"
    sha256 cellar: :any_skip_relocation, ventura:       "baaa192b667651184829a0545683f9fddcb8f1bdb820fa65f6bc50aaf00bc218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9812a6ed9ed948025e6bc9a284585d4127dd45ed3ff75ab03d8dc0bef8af5fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f4332fb036e5b8170a8009bf433da8980ff7bb6a280479768aebd33a4176d4e"
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