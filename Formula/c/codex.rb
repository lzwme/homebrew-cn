class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.40.0.tar.gz"
  sha256 "aa2385fba292d2454f3f8cb240bc72e5e7ced2e447a848173dd68e06e84dc0e1"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0161ed5b72ee0492dd135d29a8ae79aa99c6c70a98f30cfb9227e439f2c10c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0882b6bdf06fb15ba260929f3684d92e6d2dcf69b79f78a2a90bd5117fc3c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2790e39f1d36a5e1f235d318309f01f6a76d76d374f8bcec4ea5a48b8eab9904"
    sha256 cellar: :any_skip_relocation, sonoma:        "e670df05007c09ec6d949e2e88a2c2d29f3620287c10366850f003934bd87bdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03d368af1ffabad2835be9c47086ed8f850c06b932030b26d06b46e668092de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5f317aefa41b1c7e7c7427279c60b75b147618e1ebd69ef3d6e0a6589159933"
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