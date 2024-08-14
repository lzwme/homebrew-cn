class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.3.5",
      revision: "15c2d8fe149ba2b58aadbab615a6955f8821c7a9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fd3bad39f160413efbe5dea149b0f3e565bffb9ad3452028473370ede502a47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04cd5cb86f7d6b42a4e3de9145bc48af2335d9067b52597607dff3f0b8200d02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe2e7381c3d208f9aaa1243945d67f8a76721124e2841fc2ff16251f0fbf0ba4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e9f407961cde55f7d7738cc6c31a5f2189d17cc85adc717123347ecb600aed2"
    sha256 cellar: :any_skip_relocation, ventura:        "a2dc57838e85e76f7feafc7536c3eee4de726ea6b14394cae5a4e49930cda28b"
    sha256 cellar: :any_skip_relocation, monterey:       "56bed58ff421e7a58fc0df29d0188d71611b0b895c269a70ec8af22251cb29d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62b785cd98f625c66727c3a8152391980103fffe20d525aeb7ed34d16c1ae3ac"
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