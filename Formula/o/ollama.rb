class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.4.3",
      revision: "b7bddeebc1ed267004c1f555fb48fa1d48a37303"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31b572d9fd7f4202e915e80c37f2daf5eccf0be44629dac262b8021722f21177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72d7050f3f253adb0d7afb5eb33e33b87f83a68c79bf6f664a82ed52e06be210"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52a2174101b8ec8085232c34edfa4311e5160b40a07ff3f3db623d0e568e402c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad0db01f9183350b3b10e8856a81a1cf60a5b960f0e18993370cb7f8a82e0cab"
    sha256 cellar: :any_skip_relocation, ventura:       "da5016c89cff6c3e75aa0ec86a4a51b676245c9f8353e5a2b078bc9030adb92f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb8c2a61f333ad8e3ca1a14e13a62e7303adb3c2282fd2ca9d0e2d4af07079f"
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