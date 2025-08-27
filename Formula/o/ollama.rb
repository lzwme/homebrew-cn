class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.11.7",
      revision: "d3450dd52efcbca0348e9e8ac42fad6263ec9f91"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14a9a3fb24e4548c4298d4ddb79e754ae850e115506ebf643f56e90d948cea08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c578c174e99b2c49bd067003b867353371f978ac00e2ecd84a10ba6b85eb502f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47469c949afe8b04d640a312d988b3bff8fc79ed3c4f3e2aa9c3ba0876e3c2f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fd64d425d388a777f9df1a7f4b0c5e9dfc0eada45203b5a6a9892b0070ea1e0"
    sha256 cellar: :any_skip_relocation, ventura:       "287a6d21329b64275b1c967396efce32ae412e233c5f71bdcad81cf7ebf88646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf3e1eb47d928454274aadc1ebf4da5b74a4cab74e2fa0b9bcf6e20fe1635d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d179e1d4bd99b79879b5f99dfd4aff3d7dc75645431d082a58ddbc7e398fc33"
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