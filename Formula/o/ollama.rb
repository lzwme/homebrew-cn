class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.14.3",
      revision: "d6dd430abd6b771bdb418baf651952ab756d391d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f33f972ec7ef88702ef2b82835fa91fd5904e453ffa2c7640e4cf730202abddb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbd34d7fbb1b73dfc1bd9e873a9a68df91f20f13cc44528b006e8bde0f5d5c15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5d8adf7d69831e860ebfd77e4b0089cb40c013b4fe60d20a1e8376cc11ea704"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb6be0490fc1dc12344095aa6b8d2c55520c291f66727f9efccb8d26299b35a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17d3a37a9d17782240c507428ce96bd4608b1d49d353b6b25e60437c75ee3d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81c72ddc91708a0e2345f11a8166d1a62a0f75f0f370cb0e4c0804e34fda3674"
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

    pid = spawn bin/"ollama", "serve"
    begin
      sleep 3
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end