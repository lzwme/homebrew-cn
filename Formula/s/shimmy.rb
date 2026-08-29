class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "f5c1f75633cce19c07dbb42017e16c09cc3866f666424c52189a56ae508457a1"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5e6eb0a57279cb3fd15e9365d532fc1e7a92afd34549bf9f205444e0c078c4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca966f7a0b7baaef46537ee7f6556a383bbe93e3dc3a3c03a312873de3410d05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1968999e5bc2e29dd957e86d429287f1c50236cc592abbc212b1904d01d7be35"
    sha256 cellar: :any,                 arm64_linux:   "a2dee00223291e0fce164c475765a3793812ed51ee27339754d2a4ca9594ee88"
    sha256 cellar: :any,                 x86_64_linux:  "cbb304839e1819e349e308a4f335ee2c8aa850e536a45735a07e9b71ff12860b"
  end

  depends_on "cmake" => :build # for llama-cpp-sys-2
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"shimmy", "serve", "--bind", "127.0.0.1:11435"]
    keep_alive true
    log_path var/"log/shimmy.log"
    error_log_path var/"log/shimmy.error.log"
  end

  test do
    resource "test-gguf" do
      url "https://huggingface.co/ChristianAzinn/gte-small-gguf/resolve/main/gte-small.Q2_K.gguf?download=true"
      sha256 "71bc9beaecd0a3c5f075b8959f84c4cdf6c27dbc39930b0ab4d7c443b9373bc6"
    end

    assert_match version.to_s, shell_output("#{bin}/shimmy --version")

    resource("test-gguf").stage testpath/"models"
    output = shell_output("#{bin}/shimmy list")
    assert_match "Total available models: 1", output
  end
end