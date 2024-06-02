class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.40",
      revision: "829ff87bd1a98eff727003d3b24748f0f7d8c3ac"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee3f0d623ac8391ca2c1794a85326a3a8f23965655f218d5fef2fe409736123b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51545d31b85d22218304e6119963c57a46efe0a73121260a624dd2560f425bbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1ae2ffbf8a0311df689e687b6ec04f8bb5d69b57a9e2580a4b857267d25bf2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "87be54e8f56bbcb317ee65c159229c31f398acaa8cd38db2f9edff764a47c03f"
    sha256 cellar: :any_skip_relocation, ventura:        "353f366153eba13222b4ad79d03e65ded2a7c74fabf1d8373064b0dc61db595b"
    sha256 cellar: :any_skip_relocation, monterey:       "7d9bf98daa1533ca079df6f42e287317f6c8eda3c02d5903876d8215c5a67395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afdda59152339f6df8f4eb115c220ad350dff1c24a91349ee8fd0dfc5cd0a775"
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
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end