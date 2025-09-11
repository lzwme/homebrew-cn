class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.33.0.tar.gz"
  sha256 "96851954ce535837d36996759f1623a3a22ad2a63c60a21c45c69a262edae8c1"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39262afa59a1170cb63caa0bea560a3dc72d75dcfce2ec9e79f4005f50aad833"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "831343629597d3f95f28c13eaf406438737895845f85970fddc55ca7d343ec4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1fcf6465d537935b9e7e6fa714b76a0245cdc905f3a4ed95080eb0caa12b0fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "99feb2755b4398549eb37d1d3292db70ebed8999761ec25d980fcb1f5df61554"
    sha256 cellar: :any_skip_relocation, ventura:       "ffe80474dad6fde9884f7de98c45dc0e57c29595235144d8b82f8aff40ae664f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cf6522492db9ab2b3c9c5ece85bd7fedcf4dff91c015ff7789c566a83695cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4f999a2ed72475dd04e2a7a8962cf76b4dc413b3ef1bfac20d4a28f8029ad7"
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