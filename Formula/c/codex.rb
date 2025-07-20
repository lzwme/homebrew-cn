class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.8.0.tar.gz"
  sha256 "f8cfe4d38efc0e297d44f33cb17c744977b25076e7c4d85e3d038c402bc36441"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0dad747ca4465da59896751314cd762d0026947efe5530205058d2a31e54742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9e70c45d2c58933f4f8c4b5d8b99d91ba0073a2fcd10d32e4ba90d2acffc707"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cde111f8f77f6ef78f3176c014b877af7aaa7865a8b92e276e21a4095440a29"
    sha256 cellar: :any_skip_relocation, sonoma:        "543f7c01b391aea4c4280d03689873e4a0ce2a2427c2338226d48ff13b6e2cb3"
    sha256 cellar: :any_skip_relocation, ventura:       "68e9c7e14af849d3ffd1034a7c444eeeb58915a0f76a1d3270c650c231db2cf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d03b0b75de39b406e828ac98931f22f91b7fc67b716ded7817452ed5e27390e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f482f770dbf03160ef104e471126d2476262434888e611cb9f5be28b8d9de003"
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