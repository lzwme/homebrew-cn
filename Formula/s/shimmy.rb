class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "76308a63ac67c0bbd7ef97548cf8bca13996e1d25d05a0694ca251b34e13bf6f"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba668fde57a68143e7a9943331c9e730de0612e5d4ca1e2b6d06de7436d7618e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9212147ea84d07c5ec169d49c8644a5b3d6b642a143bd64f2ee85ebb629dda06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06fd6281e630bceded8af72a9a16197b1653fd5223795387bbfb9f37c96c87ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fd2590d31f752e30896c79031ee367ef125ceccf7f587cf4cdab1120ba95a4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2434ee763b8ccecd999980e631c59fe15bd11c3e4398386a58f53a48bd804696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75bb3fb1874291188d3939e651a92ece94a7c6b7fbd05f34029abe4a954a3729"
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