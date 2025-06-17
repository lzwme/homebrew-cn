class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.9.1",
      revision: "5a8eb0e1510a5a35b80649f2b88e9231716b6850"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "860e9fb81400a042bd87e826ea73918847a6431c522983eb241a61d9221dc0ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4ced40df78a32c70c99b9bd343243bb3e25a9cbb45c66e01855b709f441fb04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ec99028a37822107e09e9cec794d64a72f8717673660956b6691152e36bc448"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4fedcfcb26af28513d9d9fd5d2531729d13900c6abb0115584bec4ba93c5f3b"
    sha256 cellar: :any_skip_relocation, ventura:       "4aeb99fb5db0104880a0034f4a13bdf9c78f28b0e232fe30fd29c470ace33752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf5270ea0398c76c97761302aadaf652fdc1f1bc116bf2e6a6c3540a588cf224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65e3990de502c0cdba1703eaff82326862b29aca14b84bdd5202bb92766cb79f"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama"

  def install
    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X=github.comollamaollamaversion.Version=#{version}
      -X=github.comollamaollamaserver.mode=release
    ]

    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var"logollama.log"
    error_log_path var"logollama.log"
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec bin"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end