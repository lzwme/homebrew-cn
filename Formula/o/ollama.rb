class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.36",
      revision: "92ca2cca954e590abe5eecb0a87fa13cec83b0e1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2e42197967d24be7a4384d7f789e13825a82942bb549860ee9f5a86f3c0192c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e170b2ffa4865c33f5e3edb902fb19d908728a5a25dfd9463bb947c45b84620"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7451919b72305f6f749bc7bc75a18d56000ab9405bdd0d40de98bd1e63095e01"
    sha256 cellar: :any_skip_relocation, sonoma:         "47597927736a3fbc731f8a3819694ff898ac5dcfb24e3de6008988bd1e562483"
    sha256 cellar: :any_skip_relocation, ventura:        "0f2b1d0be436a4e196b1f078f99a0049bbbae77427fbaa3db880882cf59e7790"
    sha256 cellar: :any_skip_relocation, monterey:       "1d9fe3d384b7d058cf81d0259d04f505651ff0feeff253b327cf82ace2bbfe94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30a7e65362c54a3303730dadf7aaae2eaebe8aea8ee5ddb367b8f67e36016ee"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    # Fix "ollama --version"
    inreplace "versionversion.go", var Version string = "[\d.]+", "var Version string = \"#{version}\""

    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags: "-s -w")
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

    pid = fork { exec "#{bin}ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end