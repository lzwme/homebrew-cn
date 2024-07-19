class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.2.7",
      revision: "d0634b15961558fd5a06119ea0a08d3bd8511e43"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dfaf3c609934acb3312caf5b8f5a70585daa3415ed98b6232e4edcb8a76ca46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa8f45063fb281e44b66078519e4ce98de0f27284344db166c99ec99dd69be81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee78fb8d116d4fc0bca16e6db99ff77d990386398ffb93ded89f19b6b9386f47"
    sha256 cellar: :any_skip_relocation, sonoma:         "501229061997b4e65ecf9cc2e68a55e73235c377f1db1c2a500e75e350533033"
    sha256 cellar: :any_skip_relocation, ventura:        "1ab82e1091248ae30c7896a39409f5c014d4ee0f82a9e58031894558a62101c6"
    sha256 cellar: :any_skip_relocation, monterey:       "9cbc7f47550cc9d95b43fd66d97488987bd4b6a685e22c1622feebf5d6e13131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1da5f3af2987c27fde7e107cedc5799f4f69aad5f19b6a898166f269cb8b1776"
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