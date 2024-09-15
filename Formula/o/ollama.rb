class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.3.10",
      revision: "06d4fba851b91eb55da892d23834e8fe75096ca7"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64f1d43ebb72f5690f9383cf912bc81b310611f58ad95e51afbb1df95d3113a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "316d0d6c67a293b8aed8adf90eaa17327385c7e4a69216cf2a046ac0359891ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c19ca9f1816e56c25e7c61b142240c2c25150b5f1465d6d1bca4d03b047938bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea506503e855c8fba0aac309e10527f61de8371bb6e1c94ad0bb1edbcdff344c"
    sha256 cellar: :any_skip_relocation, ventura:       "4cee68d3cbf4e9bbc705158960e3ae55cfd4e67b2d1de10455e56daccbf1f66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dbfa26e50005dbb812dfe98caf05eb71fb60a7ea39378f0a5fe9260992cc80b"
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