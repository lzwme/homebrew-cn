class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.31.0.tar.gz"
  sha256 "96af5c3f4ca0ce8afc687e2c13d5e97a898079eea0db73d1a22bb933cc840dbb"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fc32263608d00d6f0c91f9d31dc206591b087e3a1b91a4b5f4c09bc5a5a79eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d056f29a6840e9a47cd57b975a760a08059d2c1521fe6b60f2d1c20adc5eea1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1c09776d53e171ae3c9e09f2f72c1bbf3e30dd58bb7653c532b710fd9cc5a6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c9240a51238077b0fa6baaaf401187321d625113b1eeb4814925ef5b7a1f09d"
    sha256 cellar: :any_skip_relocation, ventura:       "a4ff2e566581abee7d69c01e9e79eb27a7def11b34dc609f112705d158736bd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b445e3b861e2c9e9aeaeed93363d19fa9c19585a49dd83b3bc822849b74096e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c7a21b09973a7429fbb76689d25cd5ea96042663c9361cc298a171bca538f60"
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