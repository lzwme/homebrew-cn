class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.2.8",
      revision: "c0648233f2236f82f6830d2aaed552ae0f72379b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27825f3c6fb84af3d8677ff5aaaf9d0ab4e64b95d59971c44273d1e52ee21d7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c12e22939d800a0461ca370db597c48e4d57c1be5f7163a158e7756072be88b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90ed9be6dc4aae7ca907b6308d829f22ee9367d9ee8d3139946f1b1b2a700ffc"
    sha256 cellar: :any_skip_relocation, sonoma:         "09d5fa4626741b2ceb01451cb2b3c86bf365b3a7c1520c9040a9b6f089318f3c"
    sha256 cellar: :any_skip_relocation, ventura:        "d7a60034a3455c73278a379e3867922cde30a7d3bcb75450d82042967e173a10"
    sha256 cellar: :any_skip_relocation, monterey:       "3de00a059bb9beb009c13882a98dfb7efce950407157a9a7ecbf6982663e3ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6071952fee3614d796fbfacb718be557d802231e597727176dbf9dc8ddeaed02"
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