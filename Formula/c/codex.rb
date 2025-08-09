class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.19.0.tar.gz"
  sha256 "458cead1c33d7179bbe530944c00ec2c434ddbcf01d088e56437008165a40b3a"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85d9c48233e5d5bb5919e319c654f8ae2db9cab9ba1666094735a7b6b9368a96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1205061f41289316e6251801875e80b740cb30a3f70af39937ad607fe9876e36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be2b56e184832ea79d4a7c25d7fb72d3607e6410eeec07011a924e69f11da0c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc69df0a8f9fd30c100541c5893f0a3e9239fb38f141f8956126c1f603308de2"
    sha256 cellar: :any_skip_relocation, ventura:       "73390ecac3b25ff8f752f839e44082f455c2d3b37ed3b5f7749e8b12828feb36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8e4125b9896eec3ceb309690220f41c9c20f3009e4c81f12236b2c9cd4331d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8276689d9c3cd4d1fbac0a49d6a75f336ee341113303816aca38b7e867199d02"
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