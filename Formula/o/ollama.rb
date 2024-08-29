class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.3.8",
      revision: "93ea9240aee8a51b0fe455fdddedec2046438f95"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fedc6ab50991a3388d012278d12653a33f149aeb7efe1fb657ccdfcccaf722cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f340b408d5d90edff0ae01c4bcd4b19516e71d1656db489a11f4df46ed79745d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aa6a325d3c2d3aa62151fa4fdb35975352e2a969005f89eb01f0eb0cc1c9bd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f5126f668c9cbbb4641e6e8ce229d8f2ca69488ac2be51868fa9517eae4bd4d"
    sha256 cellar: :any_skip_relocation, ventura:        "3af0677aa8caad0b125326e5493cad91fa12ea0b0e273b63f2a1ee75c89bff4b"
    sha256 cellar: :any_skip_relocation, monterey:       "be9f88a07298773b60559c293992be4cd8a9f67d63b0e8e95803e09ad24ac764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "394b73e97a1c1e3ff4ac80d8d6d0a039ec7bac407d8e7cb8b0fe3bbc517a1898"
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

    pid = fork { exec bin"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end