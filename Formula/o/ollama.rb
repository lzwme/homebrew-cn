class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.11.6",
      revision: "6de62664d957a9b6606b39330af701b5f4a24035"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92bd9ebe762590e39409eef18a26aa9ab4d78a24d3fe35ae68e14978dd6af90c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62824658e93c5db07730fb17ad2a7a9d246a5fcb3a097112995e5c21b4e437eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5eddee81c57d2ad41df447bb6af3d6859a9f78a977ba102428b21c660b76865e"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb56b44652da42dfa9fe1345f54caa6867c3018deb2ad3e791bf76dda2d36676"
    sha256 cellar: :any_skip_relocation, ventura:       "cd19cadc4356c876d6087fbeae9e29b8958b349c8d8942c1ee5eb1afb4de9e1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96c741c2797d3538d1b1531439c07b559346930d4ad4f578fd63535481b968a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a43c7aac638c12ab7ed195b6a287990b70433769acb727e5291fba7c676587e"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama-app"

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