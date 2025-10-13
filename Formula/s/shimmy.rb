class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "a420c069d254314a11db7908b19d1f0cd32f56786d0d88701d96e91b2adb7d82"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dd629f969e2285e003919a10030e9248672f26aa0299a2de6db0e09367a2474"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d4b81a1f29a3cfc452676502cf4a374fa50bb573d8fdf1e0c782cc6cf449ade"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03adf5279b3c608ed9ab82358dafe10203a1c83a13873df4c9da012a8486f52b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b4b357d1c8cd8476dc32a5b2ee84ce92937ec5454408e20598f67436ae2aaab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4279edbd4b3d4bfb7e5897a3882ad94f7d1366cdc413ab97aaf424f0db9e0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef2142af17cdfdd9a6baa82ca14086c5a11d99a6bc37437eac0ac711b26751f8"
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
    assert_match version.to_s, shell_output("#{bin}/shimmy --version")
    output = shell_output("#{bin}/shimmy list")
    assert_match "Total available models: 1", output
  end
end