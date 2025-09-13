class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "850a862a1a9f3f09eca8e654a540672dea1f74ae48374945f31cf7f6297556d5"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "440f5b6e4521e51800afa6907ac7c973b65fac8ff78eb99ab76bcfafc95c383d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d2d0ec16e79c40bd617ba2152cd93ad177626fc69222f822a333392b3ea0084"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cd0bdb5c7e22ba812f8bacbfaafed32035ff650ca82606e77f55e7d5f679252"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf61d1b9352b078d9cbf741b4ef7d61c4bd3ff743c5cb53b5fc18331135d8ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d292a9b0b415b213339dbea67ff60c5dc9ba7c3a7cf2fda93928a2f12ef18bf"
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