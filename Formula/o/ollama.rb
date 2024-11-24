class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.4.4",
      revision: "3478b2cf14c3fa2661c03f7fd5764a63a496293a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9fa1d523236c10ce904093ff8477391c4e379d3f617172ae45d4121b5059312"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "832e7479fba5f938edf598c94e1c5e48de3224c289ab61a4366678696003a1ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd2b45567aeae6c208a7d0ec888d06dcdc0c2ef8ecce6cf87ca7ed476a2a6915"
    sha256 cellar: :any_skip_relocation, sonoma:        "56c4e5f382ec3c51a4a28976b38a425301c8661621e3edf05861f34978a29e68"
    sha256 cellar: :any_skip_relocation, ventura:       "ec8be803a66a9f23257248271065169db42d368c62932734a6b326de18c6ede2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46b0c9ecfa252b49cdcc2ee658747c9ee8034867e33d893e98e6772d5bb436e"
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