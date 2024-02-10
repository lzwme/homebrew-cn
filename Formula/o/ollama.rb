class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.ai"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.24",
      revision: "69f392c9b7ea7c5cc3d46c29774e37fdef51abd8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d2a1a5a3934eb45e1fc03f7351359a601b2557556f63b3d769602f31e885cf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbc9c0327e04eba938eb61a24e7071169a6ad440daae061bf72bd3b862cf1783"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27a82d2c988d13b6cad04c9d507a126cf6da5cd0ec32b0b073ce43ce88c37775"
    sha256 cellar: :any_skip_relocation, sonoma:         "e72bc08deb699a86f61a4c38fb0bb93d6d3f8c11d29684a61ce260d8ce67b03b"
    sha256 cellar: :any_skip_relocation, ventura:        "dee31371aa370d1dcca48cebaae84cfa1ecba383868a5e4a3b9f970192aef051"
    sha256 cellar: :any_skip_relocation, monterey:       "263823b4ec20e67eff37e032f5fcff83e24e930708044856750e7cafcf943d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a14413b11baacfc65c8849ad4ee22adacfdbf1c8a115ad56ea8b83282b9e942d"
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