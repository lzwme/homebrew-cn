class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.9.3",
      revision: "ba04902670cd5945ded682c1c9de2220475b9c38"
  license "MIT"
  head "https:github.comollamaollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c97602bce14cab2190118ace8f00953e872088828bc2c1ae31d006f167ec202b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e291600d4fa244567927e1cfb0a7e71f877d123ae2ef39edb9adfa7f4b19dba4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c0a14b9db43840b35fcdc7b2353bb58342ac18e709a1672d43a02f3b8033b7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "815497f077bca9893cbfe781bfe9f5b1d7e3b6c806b10a5b0ba24ae5ae0a2028"
    sha256 cellar: :any_skip_relocation, ventura:       "ef2200218710dfcd2f4f6ecaac428e318b54d6e835be9eac70336569b9dea14a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e4363a17529067110a6fa0d5e482f6a8b968e3adec20a6e94e30f0a24485527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d02cfad4e1a3e7ac8e34731cb0ca2fba3c16e85b1daca2ae9e42c63a0f40d6cb"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama"

  def install
    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X=github.comollamaollamaversion.Version=#{version}
      -X=github.comollamaollamaserver.mode=release
    ]

    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var"logollama.log"
    error_log_path var"logollama.log"
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec bin"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end