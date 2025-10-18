class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.12.6",
      revision: "1813ff85a027d7d4d76761a2bf12c2198dfaa0cf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8fbc6b6b01837ff168c9f41c6c8ac5d41b82e9ac73ec87e45e4e7219445f78d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54da1a7112a20398ad3d2c321bfd67b25a75db21c60820af16b53347a8920577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7045ddbe120ccb449874d7aa237d627da1deec6b9d858f11d63c0b9e00d3afc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e51e4395639a1b859f49be4999110d6dde5b965d996a497dd3819924c393d7ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fd20bf2cb9101d909077aa9f66e2050e66f03f89882fdc45f5483331e45769f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce00902d7e5b7c3b6c43f0de469c40e7fbb0a6edb0b0ec051f40abe2778e95ad"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama-app"

  def install
    ENV["CGO_ENABLED"] = "1"

    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X github.com/ollama/ollama/version.Version=#{version}
      -X github.com/ollama/ollama/server.mode=release
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