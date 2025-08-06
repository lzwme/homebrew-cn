class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.11.2",
      revision: "8253ad4d2b2e7ac58268192051b92b59986c874f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55de2dd23413c69690b4485648630e75a32dbc192ab2ce02e4882a0ca8f0773b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "153dc14ae05aba7d2e06c41e8176ea65abda973719db4d07d1e81a90e623e3a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cee92426d0e8a3bae31556e71e02c532962a5b8a222f21e685abf19915907b3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "472b384f84d0342d0376c44965f7bad74e19343c31897f6af9f171736fbdbb48"
    sha256 cellar: :any_skip_relocation, ventura:       "c2fb97eed7b2b4970b2c529f54694f63527795fcd16bde6a7dc7dd767fd6b8bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c64c12e6ca936ba3cc8b857addbc1efa0164b0e01a88774fd78aac06632f5707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f469809d6c8475ed48b767b77b2dc33f9353690b2580ce290054d616782aa1a"
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