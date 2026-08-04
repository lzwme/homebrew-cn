class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "0bb4f19f3d7a3fa6349b3334000539fb6dc52a90bd14106f4e91c39209028fbb"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e361411b17be66b342868cf9844b10bafd611d1b8525e4f97844300f9cfc6b4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74c2f9a310b3b81767e956f07c547116983ea4af23e523bf7336fac6edb6b023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "945fc6c12a0a7f62eb8f0a73f344c72264a01ce8590cf40caae91e5e24ad2dca"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2b9332c2f7a8fa8de70806a6df64e704a4d6f782283903b9b89929c3c427bf8"
    sha256 cellar: :any,                 arm64_linux:   "f736db4d6cf9698d6dc3d79cfb4ed16c381b68269e24eecf0f87e8384f041ddf"
    sha256 cellar: :any,                 x86_64_linux:  "33127f31344334aaae418f1de7f17d0231ab991e41b619772894136709fb5b2a"
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