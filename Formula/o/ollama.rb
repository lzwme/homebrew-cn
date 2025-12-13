class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.13.3",
      revision: "709f842457f40550c88da80f84bc8d7ba29371b9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3a8adf969fcfb82d5ced6b79d2bcee3fb58bea0cbe1d1a6b1e5c1fbc1ab190c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a4591eb6bd2e150b518abf89538bda832ef58afe74104e0a6b0c86d0a87f135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "039fcc7efcb69cd7105fb8b4ce0c5c0e6adedc557123b85efe3d54e867fe5acf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e4a3af0408307bf047d193746d1e0d806db5b2aa2c7d7848c0880f5c16edbb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "303df57f07fb173a8d0dec97a2d538924c2b3de43c0175066e9ea549306a8ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0053b30cb052d3fcee56d720a3e06622411a59f799a7d9701ecd9e9c6c2b294e"
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