class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.10.0.tar.gz"
  sha256 "025c696a26eee9071f35adb48ed6ec9766431a202fa19425f4e1760f77bed108"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b93b110a1ec1582e439ef604099e3de9fb1db3b2d0d52d0ddb6efd2db24d1db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "998bd81d1d5f71b4eec9fe5e657672f1bc2c80b12e685f61c15d321153353255"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b91f70df0f6ad76743b1b318a5cf28ce72816ec77fa6151b7d446a0ddc450be"
    sha256 cellar: :any_skip_relocation, sonoma:        "12f288af892905c06fb1505c1547701013e6e035270c788dff8c8f19ddd5f340"
    sha256 cellar: :any_skip_relocation, ventura:       "6c7a8e5c0c9ecdbdf3a173abc5a3b9e33bd1e18de2817b8b6d66b93263519bc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ea4d3bf1091efaa2aaa4d5c8460cce604502141835213f0db9a239472aa4899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a65476fa61cbc9b685b6a8e33c4deae3c1c3b11f7d207e991416002ec4796745"
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