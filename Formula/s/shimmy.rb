class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "21c886473ab013b64378b28dae720159bfe5460d5d0646716f672596e1d80319"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f93539656a75112a082abebe4f754e1b1397dfc9504be25ca61665a6b0634b6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4ff315fef28d8620f370e67dc7a49c4cc8b8397b0b35d4ac6c2ad574a537c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12ca928c6e24b162030bab5f9ce4043a175222c24a97791628b1c9a148c898ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "865091f50b94808236bef2c0e69318dd602391d625b7ec3f8ade5afc4a064aea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82b4069f35bd4bfc0d7b770dc7fe31212abedc37685f2722f9e305f69ad6079d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f7ae2a52fa27232853933662569a0e3227c6a87936d92a6b8174f94cbddd872"
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