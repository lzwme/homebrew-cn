class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.12.5",
      revision: "3d32249c749c6f77c1dc8a7cb55ae74fc2f4c08b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c9a67d1e651c4515c0fb74da097f0387d347f273bb44b9c1ba15a8b86ffd5f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "606c894e362e66fb19cfc9639b12a50a1bfb0746c33e2676ab898ca29a2da2e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b561ba8a4256f8775231945cdd8d4aa26d651bc5a90165010e85795506fdd7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a73bf6fb57f2b3b498d68dda064f7493f9b87e0e8fc0d383c19a7b0ee58e2ec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a881fcb9530fd0acec8c74d7ac64f30c336e69f841f2012d59d0b6bd16c4c555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cd497221b5f227f200f923851631ddfb54d8bf4eb609ed4de6121addfd85468"
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