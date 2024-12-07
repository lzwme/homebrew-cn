class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.5.0",
      revision: "aed1419c64748f31e66fe04875a6696b70761038"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08e2ab83e6306cacf428ab799bd32772e7350c66fb7fd32e3d3d3560d7b49637"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67c56723711ecfcf2a9f6c436ac10c6e08fab826dc3b05b303b8d930117c6da4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6eed0bb49b0b38edb08cf7ef40e6274e6f8ccbb7e7e797bc2fdfdb91c6b19409"
    sha256 cellar: :any_skip_relocation, sonoma:        "1568e84b270ce71db7926dd8e9d5fe525074205d4896017f01e1dd83d9b61e07"
    sha256 cellar: :any_skip_relocation, ventura:       "109793d18acb50d501b86ace9c445ec7bcac42628194e36ae51114b6a776fd9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e4e7dcde11ebbbae051e3b420882b92084c4492405506bf70d1c2e8f23f3792"
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