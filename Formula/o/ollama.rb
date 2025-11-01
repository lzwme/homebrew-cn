class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.12.8",
      revision: "db973c8fc2579e97fa4b8adea5cb88835138b3ee"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "501a3bc071d35055547d05c5b67fa1f6f8be5024b93080aff0b73cf195bd893b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e98c101f92e0f9ce6ec1d5bbfef97cfe884e92740e88f48153b70e77413075a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08bb3643419d1223d5b35d8d94b8287b496e788496cee1decfdd22059eeb8924"
    sha256 cellar: :any_skip_relocation, sonoma:        "8db37068d0d1a28e16d4749fa726bdfbe1b54d934611d661e5c581e0e6833113"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b17136974beacbff2f3d0c363d01cff1454fde16a7ca5147c6668d73e3696ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3081d9c3fe713c2420768182a888d57ea2571a14908d5def571dd2ce0652dce"
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