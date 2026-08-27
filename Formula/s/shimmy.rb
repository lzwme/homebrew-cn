class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "b319065509860b1b087ecd17f191cf447a4f51061a008d5be3829add0f3b4c19"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9e65e50307faedf841dc9667a17a7a075918163a50c8b98b88a4794225b0306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8bff3b860e5c24bbdc9c137136b3c4337aaf9a4e9d4c946d7197c1b8f1be5cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d86d1e65a5280d72eab1a6e42b4e7c0db231bb31b946693bd74d185d50c3f306"
    sha256 cellar: :any_skip_relocation, sonoma:        "0acecc6968eeb88d64ee766c0e657113843a17954a14a0df52eec0ce9a1de533"
    sha256 cellar: :any,                 arm64_linux:   "0a63f1922aea2b1985fed302d7999b0ed6639a6a9a5c33b62ff8de7a81630155"
    sha256 cellar: :any,                 x86_64_linux:  "0712a0d956cae6e6402b70cdc778d949e42d6372acc904907366ffa6f3822284"
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