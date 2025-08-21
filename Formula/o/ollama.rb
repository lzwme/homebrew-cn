class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.11.5",
      revision: "f804e8a46005b36e6f14577f4226cf2046abce12"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d12243ee7c2b66fd331adc967d6bbc1b9d05ebc6d84fb28af211c10cc2e9b97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cbc6cd2a6b4dcfa8060289c94e209a386ecf13fe7488f8dea51cf01b887fd0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "644d3c1a7190bda2106a7c989de1f2f9b382e5b6e4486195213850228904dfa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "505f639960933919e6ee013c358ba0f1de024506cbe00cf4f41c6d45d48cfbb7"
    sha256 cellar: :any_skip_relocation, ventura:       "2f71289d33f49d2bc3543a98fbbcaee4128bb0d0a268aacac8a96ebd1a400e42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec0625de91848ba44a1949b8f1496e6e97074c606f645d8bacf51a7bfde02666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "925ab3cc0fa41e6948a507242628c102ea999b205f1c07a4f434af872905b8a1"
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