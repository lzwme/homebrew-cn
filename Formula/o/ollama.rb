class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.3.11",
      revision: "504a410f02e01a2ec948a92e4579a28295184898"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7441869871624dac970e1184473e817e954f1322862ecab7d17face4bb9996c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f56c287086423496861d02235100f01367587ede88c5e34644c25553495f7f57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f2d277d2c9d0d43dbe001db798ed595016c3d88cf066f83f94cacad3964bb7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a6f796a9e3e2f22004102edb4779d9530132fc3b3d6f1ac23458817c4a470f4"
    sha256 cellar: :any_skip_relocation, ventura:       "3a690ac0baabc6812fc3a507e509eeaac62eaded76dedf6d55608e9d6e67af45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbaaf2292ab366e2014a3b555d76e987c50eac8d47d0174672d243b0da550ecf"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

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