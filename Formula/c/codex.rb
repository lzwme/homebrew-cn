class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.41.0.tar.gz"
  sha256 "8f73c6f99621aa106d0a5a62ecee5f2754521ae05a6cd90f2b9a88b8cf24d749"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7529a0362a43ff2a15ad46a3b45f41ff08bed5761ab71c3c772634cd448437c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75e62e68bdacc75439f072a777501618d8c209b8c397dffc4677cd997928d998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3941770c49f1e959fe9b6c702a00e48ac34b4ace2cbd1a95228a543bff9a5b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f0b8888231331e8cec0678b4c00e761543f592665dca7028500f2f731e1400c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec27c8d0222a3b4355e8a7e899dcc66889274af7578445fe2d1c1dbeca8f9572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca006447a27804fd8e0b8bc9c2600ca6c31886480e05d6b4b21ebd54420edce4"
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