class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.9.0.tar.gz"
  sha256 "1894e1331e14fd44cc6f3ba497faa47527d77b19b72bd961b1619bad3f81bc2b"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32741e0504a4d7678ea6161a74bc5cb880117f0087a1502b45602451313ac6dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aad99405f8c738df4a69cede7cbc23ca13f6462ac42f0e925d662f43cc2e0432"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7eb0a86fa6ed128a98fe9bbc9af211ce10293bdc5fb0d1ee12bcebae807f6a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2701297d4b79d79615a689ded450e66a4621f0bd7cdbe4beb461a72cd6fe385"
    sha256 cellar: :any_skip_relocation, ventura:       "1a4eb706b3cd3ba70672f468f07f54354adc79513f22e6e70b0074a4db68960a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf9d4ddb2cbe808e27a7b5f8cfd881b058e7c5f743b52887c9768f4147ceeeb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81aac6b248332d1b1f69bdb4267f700e41a4473be0b734ed16f25a10154467f7"
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