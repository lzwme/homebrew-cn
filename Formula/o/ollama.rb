class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.5",
      revision: "cecf83141e3813ad7e268521e6a95efce61cb146"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf281434fa56c02f8474a63a386a8866cf0d308643da076ad5471fce6be12bf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca857a89af07c0e05ebcd6a64ed2dc2072b945883b247358490e8c792e5ae4ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2ca01a6729c88b19d8ae31e08c714005745bcec58dd8e96ec6426ff55cfb109"
    sha256 cellar: :any_skip_relocation, sonoma:         "db755fa424b11ec7d0184bfb68b963711e4d3843b88e5f624abcf9919afcfba2"
    sha256 cellar: :any_skip_relocation, ventura:        "ef71c23af31ed9c779eab523775cf738dacf599f0723899e9befb9ea303c3966"
    sha256 cellar: :any_skip_relocation, monterey:       "1717c8cdd3306ea8410bc0fe5303d4d6ba56c01242e3a55f4db1dd8558ddac5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bb5a5dd8021c76623cf4bd0ab33f0384465c1d66e5ea52fbe887fb8afec83e8"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build on big sur by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :big_sur
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{bin}/ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end