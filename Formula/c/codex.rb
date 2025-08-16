class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.22.0.tar.gz"
  sha256 "eb78dcb1e197093e30435f04751f6c996317719434be721412675a9308e42b8d"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc3833f51bb78d9cf8c435c029a0d788650b88fcbef04b42c2893b91df8f8866"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2707626e0ec0e9c1f1def19da1475300698d39ab76388d50309ccbab26471aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9d7e48254e9504c209b0b62a93f97ec79588f7c281c5921bd1e1313519b6d09"
    sha256 cellar: :any_skip_relocation, sonoma:        "941de51768e3b7e8e0bb76e8a5dd18da0b0ec77c45632a7efe41070800684a2d"
    sha256 cellar: :any_skip_relocation, ventura:       "43120d71015c73498c90a1be437d3ec2223f5b6a01db844ee715845d11d4ac73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "461a3e414234048d6e112ee95254c0ec14c945a5d76595a9d4f81c3b359d228e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "580c7e14e666c265f91ef85c80c1ca8591fe14b4545b11cf8b62a59f0d80e4b0"
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