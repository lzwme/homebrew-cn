class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.5.9",
      revision: "a4f69a0191b304c204ef074ccd6523f121bfddfe"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef8bd3f98b69d58fb3572103581323f2089866862d3972ddfafc60763cdd7047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdbe35648ffbb0e28253ce0fa754d6ea9bb0e41b8ecf28114496443d6b836a27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67217e81cc0088be76f11d0cd503d66140db1845c0af0fc29641d1a0b2e90562"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea7158ebbb90903480936a8e4aee193c11124ef55b2f01f4da4bbb8701b023c9"
    sha256 cellar: :any_skip_relocation, ventura:       "27ef1ab09788bf2b66bedbe6576c6b5b2f5bb5a23d29388debab2bac328475c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deb89824c5157be5dffa825c39b2b7ff35140fb127d0cc931f1e873403fb78f8"
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