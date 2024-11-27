class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.4.5",
      revision: "2b7ed61ca22743598db2b407a94b8865042f1078"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75fef3a325d3131931d71e4c6e041b1444ef9f01ab66bd369a781971b422ef8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24ec519c68682685b96bfa623f076a47e76e65674a44276c5fa0d51404c8e933"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c46fb33a78bb9641576c82f0b829a3b74383d45c2fc2d262c47bb50d628818ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8fc2acce854160193d8c8262ae91cd6cce5452bf5cc3a0424be0486cb2a322c"
    sha256 cellar: :any_skip_relocation, ventura:       "a2980f25e9ada76b9757531b032907329e95491ce0edf673f4a05385fddcb7de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a806688945eda8b2730ea9f7628f855d060aee7448a4edf8b915b4ce6bd5c21c"
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