class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.12.10",
      revision: "80d34260ea16e76c9ef0d014a86cc130421855f1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cde7cd88fa193462f1fad42f6a44880ed335fbdfccbb42f598833b70fffe694"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a133c439145835f3ce71a8da8d4b9bae6e61bf5d6eeb372949683ce9fc65eb19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbfe209de605c42d51365f130ffc9f38903a671429942d403f789e7d48e62165"
    sha256 cellar: :any_skip_relocation, sonoma:        "264f9772d88ccbab358300fcb689a87fcdf57731b5e3e2abbd321f0993f05ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36b494ead0310a3149f7dc04541583d0f3277c6ca34120980631a796a3ba3b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a045142a45c8e403c212c144ecc0e5cc5bba3f90417922dfefc2813bdf43e26b"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama-app"

  def install
    # Remove ui app directory
    rm_r("app")

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