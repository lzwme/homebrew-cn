class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "0b1cecce9d47010e24230e6844991467f5d24a59423879fe07db68d3c1aeb852"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdb4caadec2f8eb637a146fb877b0707e9e4ebfa2eedecd4559f34eb4635a149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c92c710bfbeba92a5a1b3a53e468a435e4779436d2cfa38c10ae9d735bcf3970"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad930ea69810d8682a10791aa8dd9fd293296c78c26a130f5d4388957d9483b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "317b9e0651962e6c1c2717ddef9dcb52b691fd1f812a4e72bbdbfb6943299a7a"
    sha256 cellar: :any_skip_relocation, ventura:       "d8bf2100b3d23986e8dae8dde12dc6340e1a85358506403393197bc34391b476"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7861609e4926eff0d0ad68b79adaac4b6a06aedf20574f5536b0643958b57b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d3f72a1e84bb0dda4ce7667b1ca3320b032504e0957acd8101d8daa80127972"
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