class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.14",
      revision: "7db5bcf73bf7026970e988f56126db8f370f1b11"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18c0a1dde61b9dd29d07bf74b79f402fb081a04e162a27a45ea8f4294abe0a94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f66e9bcaa8bc20b72454ee7d64f1a9f28d44c75d7b4e4a8899688658e42c7ed4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c061fa1e0cb3235fbb11af2196296fe6f59255654bb42fd863248521c061575"
    sha256 cellar: :any_skip_relocation, sonoma:         "5215fad33cb77531e4876b8bb50bdc1cecaf647dc3c1184ceb8a911b41651a16"
    sha256 cellar: :any_skip_relocation, ventura:        "45fa172c75be009b987b4ea44679b5a5a6c2ccf50b8885b36efdf8e3175b5ca7"
    sha256 cellar: :any_skip_relocation, monterey:       "c2c9ffc33f6882cba9edd55b0eceed78a1788797a2cf6e38f8bb1310d68dcf7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13af0055f77a10cfb37ba8fe16214d78346323e8137280b84212899dcb7d2173"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build on big sur by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :big_sur
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{bin}/ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end