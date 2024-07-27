class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.3.0",
      revision: "bbf8f102ee06bd6b149e4999571c0844aa47b12f"
  license "MIT"
  head "https:github.comollamaollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f347f611be9fcd94c97c124fe78fc7037c9f33384fd172bb0fe878b0c74719c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e80a101364bdcd717a0375ae7111cf8ca57fbacef492e575b7cdf734ee3d934a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e0d79b085493862dcbb255c4860e770a34b08eff8e6d345a83105eae16c51dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "b60a6153f85d9b80ecafe9810a1c9b463cb341aa2ba665dbab3da81fdf906f3f"
    sha256 cellar: :any_skip_relocation, ventura:        "3c1eae302096194965809d084d7718aa49b78765de10ff71d1b605d757fa4159"
    sha256 cellar: :any_skip_relocation, monterey:       "24880cc9a6e139623621bc15da956bb2beeee5e409fd56ca24eeca65ab72534f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "997906811fc2fe7985b529fdeea8c603f8e1246bcb0dc8b2fda4096b5a566437"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    # Fix "ollama --version"
    inreplace "versionversion.go", var Version string = "[\d.]+", "var Version string = \"#{version}\""

    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var"logollama.log"
    error_log_path var"logollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{bin}ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end