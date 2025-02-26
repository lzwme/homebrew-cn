class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.5.12",
      revision: "8c13cfa4dd35a79c983eb19b5ec2be7ffa220b69"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdc73daa59db7ba9a59f8d83959ccaadd8edfca8776952256a8f0d46c2148628"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d8f3ee222f75dff76a9ec98400d914f8bfc5a428cc28c4ac87bfea523875df7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "717c6c3846dbfcdd2e84c9c02eed2204f308f45e398fb75ff181512d9bb4332f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d060f5671d487e6d2b5edb455ffa995957da53434a77c2e08e98d9933d97d3c3"
    sha256 cellar: :any_skip_relocation, ventura:       "479e8595cf64be58bfe6a8d65f595f3bc0e89d7353c72976e3a5193c10e89cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c835ea467654fcfbf7e767f5bc8cdb60760f2fef2c4c361cab9153486f64408"
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