class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.3.9",
      revision: "a1cef4d0a5f31280ea82b350605775931a6163cb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed0184c5d99bac1ddbe92009404af8b5b6bae6230a95a7a5b7dca6bae8b57875"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7be4081d1b10cc8d1ab998eca7cda1a788c3cd548f27ac513e082de9ea1e0650"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de1c22dbe45f62dcd9e6425e897cd767b293b9c086d971e2d6336d36cd344a18"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cb9d56cf374f9b502df166b1b6f0ac0be0bf25c83df41c22ffd112a5cc2b47a"
    sha256 cellar: :any_skip_relocation, ventura:        "8cdb70b8d3f573ee365bdaf2df4af59a109ef0be81c9b8f05a7b7aa433942781"
    sha256 cellar: :any_skip_relocation, monterey:       "277d34feef2e648cd7fed1d0a53836cf0286d247c8fb9ff720b4653acbbe2a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a665044d572520e302b4c79df100a572c46aafdad18dae5fa1fdc3ee606549"
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