class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.5.6",
      revision: "2539f2dbf99ec1b8f44ece884bf2c8678fca3127"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "178e4563c29f7922e48af5926fae3630ec36345f24c325e2fc0938ebecce1874"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47095692039e3ce81758c9adafbe4f645c033887de9a9c966e68832c7b7aacbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "300800c3bce6addf15647f9379d271ce872f9781d5714ed69f9cb46f1ee17dbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e61426cfb5be6514174633c8ad837fdf6b1ac525612abcd611492201bcb97567"
    sha256 cellar: :any_skip_relocation, ventura:       "a103c848c7b425563057a41a3327960081d2267632c4c0137ee1ace1d2d1b7c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f93f058e253bca6cab5c5d2c52340d54259905211b4616b8decb933420542d"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix to makefile path, should be checked in next release
    # https:github.comollamaollamablob89d5e2f2fd17e03fd7cd5cb2d8f7f27b82e453d7llamallama.go#L3
    inreplace "llamallama.go", "go:generate make -j", "go:generate make -C .. -j"

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