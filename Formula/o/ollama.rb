class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.11.3",
      revision: "4742e12c2360bd2b43aedcf6d11cefc3a048f791"
  license "MIT"
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e053b31f74b3d0f2c9776e215b350f1680c34f926676eba5b4f1d0ba30afe22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac03d9b0b4cc770b6170accd25e28fade693456f474768f87623b0aa402bd5bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f876e25a154ac7f44c56cde854718f72fa461a09017f8e02e30c9ce09b1b40bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "05080b1e0d40db606d1e7788bf36cd7a5df09a7a17ace7022f8ab1bb0766937d"
    sha256 cellar: :any_skip_relocation, ventura:       "f21cb0827fd21310bc60c730e159c86e1eec3124ea23a2a56c62141e54fcb9dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be5ca0f9e1138d338a6abd366ad654e7bb033ab0d519615e4a52718f90aad59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d77db8d54eadbec4cf27f696834d6207a9cdb0ed18918f0ce111762fc7ef51b1"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama"

  def install
    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X=github.com/ollama/ollama/version.Version=#{version}
      -X=github.com/ollama/ollama/server.mode=release
    ]

    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec bin/"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end