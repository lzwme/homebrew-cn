class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.5.5",
      revision: "32bd37adf805f5224a4fa18c2d4e7f33d9a972d8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99d8c30b92362f27a4b462767a3c7abebb9261632877c3f3caf54df0afeffe59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a26badec2ddcf5c5ebaf2bbdf2b954c0c42eac944c0a4bb402a715756c0f31df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24c4e59e3a03cac23ab006f54b18fbdef00d70e303c603c6259316e284931465"
    sha256 cellar: :any_skip_relocation, sonoma:        "3338d4d6a62e4e64cbe22e605e9872cdc279aea497818775bea08c36b35d8f9f"
    sha256 cellar: :any_skip_relocation, ventura:       "074fa9e55ed0274bad769b123bc157a91de63971a0ae3d06910997965f291ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1076c0fc3df0d8d0f26ba01f299d6e9f52c712629186adaa21a1fbcadc2b4b47"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix to makefile path, should be checked in next release
    # https:github.comollamaollamablob89d5e2f2fd17e03fd7cd5cb2d8f7f27b82e453d7llamallama.go#L3
    inreplace "llamallama.go", "go:generate make -j", "go:generate make -C .. -j"

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