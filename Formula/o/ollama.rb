class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.7.1",
      revision: "884d26093c80491a3fe07f606fc04851dc317199"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7cd38a476707d2e15fc4c968b6a535a470ee3206c09035fca2dfa6d17686917"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c3c6c2dbe3304c7303f49d553129cc60907f55886ee007c07ab31bdc72f67f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d503f8eb16047969abc66f42337db147c1f654921f83099fdd3be3fb895b1b43"
    sha256 cellar: :any_skip_relocation, sonoma:        "82e3ebab42ce903e93ecec3b7aab8baff852cdad77f119a54473c616568f4a6f"
    sha256 cellar: :any_skip_relocation, ventura:       "0df1e3f01d30303debd061819859643b5b0c2b72131d09c879a12b673e182618"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "474a9eddb4ed393988b4040e76e56e0503486e37e4a9dc8788bb66f1c1cf84f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f95d1e39c9817fc94c21bdcc0728708d83b78a8e602a4166278cb3f3fde67d8"
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