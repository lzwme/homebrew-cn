class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.6.3",
      revision: "e5d84fb90b21d71f8eb816656ca0b34191425216"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c64d981bae4647d8e0be78d36039152fca7a6edaf32b28637d9b1a9b90fe61d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c04771b0f108479d398b7fcaf5fbbc32d2f6a85ab25fa069e1e5edd4fdb6677"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8353962bbb85c53708d72063052710e3e19df437a2ecea35e9b781ba9e2628de"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c4edea2aa1c0afac09b8d99a099cd6067ee372870238eabce00980d624ee545"
    sha256 cellar: :any_skip_relocation, ventura:       "05bd89df7082dfceef0e6d079f2cc07942d0665a1f81b1718de1240083e3a97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f44120e525f42b543fd1982c649b4c738def0af3cf0b0a37148780a5ea60b528"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

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