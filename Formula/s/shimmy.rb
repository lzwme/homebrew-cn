class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "01b9b491a45f3e50f7816338f5a7da83f13c4db761423c343d8fc6b7589d9812"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bff4980e9ec30e1de334cf3bd17cbf183e69d734d51c72a58b2fead5ff22ed46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e8693a5e70d82516d81de51099b68e7838b8b4470dafe0503735585d3614e7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af48f158cf4d98846551cc5884027460c046ef60d313cb901917525aaac13552"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc853bd86fded5381317b22fdc6c71c398cd02ad318868734543ceb6f3fc96d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "862611bf4ccb50ee0e9fd9ef6f13d477cb25efaf5174ec06a188cebf7429cd89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6a79e70d3077886451323536b5b6af000899521b58901b2620c0074ff0e0c84"
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