class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.4.0.tar.gz"
  sha256 "e30f904e3a3e9edac865463b4dd7485ee693afb976bf09bc10806bdb132b1d48"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dabd214541266dd97a57bef7cb084fbd36903ddb2713ecbe203331b86984ac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6da9bf13e8e2129e5beffd69624cfa2a3ee22708873d3cebb77bd20102d02cb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbfef39f00ba549efca7d652d871ddca50bd95e74d83b8f81060663618b5efeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a117912cf6ecb95cd4724bbd55b45644533862028969905484677a2476cf42c"
    sha256 cellar: :any_skip_relocation, ventura:       "ffaffd5ac0c8c852c43fbf73e8350b62cd9898a7f5bffbc4adb9bad43d9deebe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfaeaa71f178fac08036ac02bfe2ffe9c6d66a78a859400817dad5155492f703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e091e97d43e08619d18a505e50fe491340f3dc7479d4a01f52f72e548baf7ee"
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