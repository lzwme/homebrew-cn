class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.4.1",
      revision: "c2e8cbaa140986b6a27f2c795e2fb9b38e74f094"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0299fb44d39c1946da361f74639f857f439529cc7d37368d9afba487a9450e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e074010679b88cbe4ea73550467913ea7563327e38f52296f3efc90d51ba953"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "211100cdcc1396ddbd5ca0c98d0220565b3f98cddd5bd3da705bc67e8b4f2739"
    sha256 cellar: :any_skip_relocation, sonoma:        "621b4b1632ccc686d70c98f6482ead743592affa4ef7f07f4d7c19c60147f6a9"
    sha256 cellar: :any_skip_relocation, ventura:       "4668b654b4ad5596cadc8c7f1dbbc6f1af4304e28b6ea00be3a324d0830030d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22eaf7baf7536c6cbef61f1edc5f480a0434f29c58c609b485f25204fe02501f"
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