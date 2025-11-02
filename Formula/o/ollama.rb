class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.12.9",
      revision: "392a270261dfb1d1cee1de3713836b503a7526ce"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64f331697b03478b3c7b81ee9e7be4ec2302f661d82da1459e1262599dac6276"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5f0bfdf239c72ad18f0ffe2c18709e181893430097d83acedd610d38d801709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0910330d5837dfa0c5a1ebb40cedf7645be8a4c3f9ccd8b13f37af83c69a923"
    sha256 cellar: :any_skip_relocation, sonoma:        "c772d3be2d24aac83dd396c83a5fd10d00dfa76b3075a2a9e830bf8eb0a37da0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddf205da5d6b6410a9a04b97c9f178d9c53db1c88db08cf476db9d2e03bbecd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "653b23ece17ae57a6c925e24cc2ce88db1f51aaf9b21dce0209e6413a38754a3"
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