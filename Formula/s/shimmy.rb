class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "693be6630afc837f325e1f498af33fffc49b8cbab45e96909abc775cd6cfa0e7"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "780d75cc74861b1ec629651dcbfbc91cd2b58ea7f3e040fb21777eb05bcb74ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e07743560080a85b1d4edaf0f8359034b3ef5051db2eb3acceb6ed2004f7b426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7b16304a748e8970406bd7e6b73f7cdc335f846302db43a1238fe7761c5b7da"
    sha256 cellar: :any_skip_relocation, sonoma:        "1220ff2e7682b126793aa7e8a7500e167a68da633cbe8615df0a0eefe84b5a50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74d221b88502abc4dfa3223df96d49f6e4950d6092540d09ffb38e681104b268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6623053944de1485452322a10f3ca7e20e249323c37c9aed217fc57dff600880"
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