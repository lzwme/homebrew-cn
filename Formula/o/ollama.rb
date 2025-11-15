class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.12.11",
      revision: "c1149875234a51aa1e5e60b74f3807f5982c60fa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e40abe0089b5051e89d982799992f2d5d2d7c094bfd60921b40c603ee5f5f34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d56d9d83dcfdcb468a3d0402825f30ec569e997c56f597b4427800db2d0731e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "966e297c3fec858fc0c09de6d025ebab3a5ea692f257a341af47c186e44490f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1893cc47783726fd57c22bbea31e786b7a57a243bb89b0c0f063310e38d96c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b4529411099b44559b11743ab454b16cbcbd1987ac19abea297f103bd01b7bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e706d292a1bcfcd702aedc386f83707489c7abb564b3c03caac5ea210fd32190"
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