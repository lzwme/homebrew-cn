class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.5.1",
      revision: "de52b6c2f90ff220ed9469167d51e3f5d7474fa2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0991ac240ddf817e5095b2f8f2b7792a1e90fddcafb79ed0e9e7921054bb2743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "098dd85e8c356946b2c71278eba8c53a4bee7883f4bbeeadd05c5c1c2123dd3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04e3c390636bb50c0aa81993b3f5043dcd43c5e144f961f8aa97a614596b350f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b38a7321f62085256f94fe8aa7b54075e91b63e67c6478f6f2aace786d2f6a53"
    sha256 cellar: :any_skip_relocation, ventura:       "cd6194b6b45552047ba91fd3c5e6272500ee777f7b183de345f3407aee562f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "936a187b7c967314f3996833343f1ffa2d325f2b69af800a8ce6bc0caaf84b07"
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