class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.7.0",
      revision: "bd68d3ae50c67ba46ee94a584fa6d0386e4b8522"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b12511e015536d79ba3a5b4c4f7eb0d00e595fe0ca6b993d9c2f6c648127504d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b86e85c211c50aef0592246496264b9faed72f86f5ca6f1e46ccbbba0737c7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0bcd6c503926548d11f194539d2f2b7d11223b62b8a5261c5f45d41a38e2fb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b742ebcc4cfbf9b068d31478946f2dd29f344da12284de47ef6437f2fe70b77f"
    sha256 cellar: :any_skip_relocation, ventura:       "18424fccbc163c861f4da1ed533264c43da7485691e47e0aa99f377c075c1a38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbde55fd77e661b659863c334c49ed30fb78e2077307834996f12f7e7194764f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "701dc173be8b285a7df844d277fca713631787fba0fbd84af4e68b0c7cfed349"
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