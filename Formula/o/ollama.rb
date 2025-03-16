class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.6.1",
      revision: "4e320b8b90b8a698fc3c057a3f54cbabe59b543a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cef9525b4458704b2005b06c29d84f9226bb8a0b2a7a6c7928b617d07590a57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5a78519bbbd8d3fe03d48f0d15c144a533f65f10e85d3c96679393aca111e21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "306e8e5f6823b158b9d275189032b2dc710362d7e04df50c4ea512f663ac6c5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "641b184919de8f28d7438a951670b7b9e21fe9fa116c4a2dfd70b4b5e33f3a1c"
    sha256 cellar: :any_skip_relocation, ventura:       "2573c13ff7befc3ad5c4279ff41b00aa9becb8b48e531864ab1bb9a4a52d1289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06764332b18d8c471c00361e6f81589dd335c76a3495f847cb134f0b151ea156"
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