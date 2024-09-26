class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.3.12",
      revision: "e9e9bdb8d904f009e8b1e54af9f77624d481cfb2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a55141778f6466a4177f87db3c9693bc8a7ab5730919e24895888d50505e103"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b396ce9f32930b7dea1d8f6a4ef5bcbee4269755629d335beca0c026c29b636"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90dc99f4788b0033b1ff22a7c1c16d94240484203ab42751e1c1c227e29c89c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "84bbb613e355a95634db587e92e70745fe0c1247a1d4cf772321ba30d7a845cb"
    sha256 cellar: :any_skip_relocation, ventura:       "326da8c1dcd2c0fa46d6947017c655bc32708b63f2783671a7b1f7c68268b0b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19b45b966d9f4369325b9eaeaf5817c125d321584d00db5f0f78e927cb66fdc7"
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