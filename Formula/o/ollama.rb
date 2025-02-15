class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.5.11",
      revision: "f8453e9d4a15f5f54b610993e8647d252cb65626"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "619cacbaac6a70adf459efe30c063804051c957c30a4edc4f6b53f57779e3fea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b96b3674290a37df3cf897094c7755a2323165ef303c8c0d85dc3cc841e55abb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61a72bd724a4005a3469f9a979f5af8efdaef84ff0006dad37954da81d9abf96"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac57a7205eb1cd1ee179123c9a24628210c56136a17c0f6dfee175c3b3071af7"
    sha256 cellar: :any_skip_relocation, ventura:       "bd836041c04eb5551e70a17dd27bc77596aebd2942a97878ac4ab1ca1b15d6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56329958a82294ae62bce30d942ed8f6a09df7426d997f5ab8373b385342bbd9"
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