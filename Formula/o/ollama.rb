class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.6.0",
      revision: "aee28501b592e2fe98863212913ffa8fb22e1ca0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6dc0c05e24e79b7c9dcd1c7d1c1c798961c57a3818d5b6b37349afa61d9454b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e5e50ea9844a985279248009383819a9c232a393b9b28706888b401f44be152"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b2b141cc8d065c855095a3952ff00df2bc569d84e28923ac87ff1889d5eb579"
    sha256 cellar: :any_skip_relocation, sonoma:        "f05582552b13096ae536c2e31e557816a5b795bf48521c284201e31f8f6542c9"
    sha256 cellar: :any_skip_relocation, ventura:       "9e39dccd7226e704ee13e3168dab8fded08a19c96101c5387bef87f8a73ee244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed89b973079f30870d92e8bf4aa52a07d2ca9fbc08f8e2b37d33a155caf38dcc"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

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