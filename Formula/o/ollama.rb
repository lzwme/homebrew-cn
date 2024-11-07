class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.4.0",
      revision: "9d71bcc3e2a97c8e62d758450f43aa212346410e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22562961f1a2fb4519aea64baf15a04fed79f06067816974b7ecf32a12891c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf1a9169e73ff305028608c01c7a027a7aa82a8f01de718d50b3ce4aa0e006dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d5e04c92be36f8e2a8260360f1d7fed5220a9e6f7da469500b5a6782f9ae4a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "59cd01ba085829bf44122ce29742cad4a12da62226df2fc93db4c0b093bddc88"
    sha256 cellar: :any_skip_relocation, ventura:       "4d91229842d98247da9bb05a154ea34141db1802d372c7bb9b704048f4226bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06c2e327526a87754c50e81956facfa0be8e72a5ab12c63e9582900581e11508"
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