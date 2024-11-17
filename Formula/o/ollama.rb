class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.4.2",
      revision: "d875e99e4639dc07af90b2e3ea0d175e2e692efb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d282109089904e97428a38c04803234fb2ff8384895cae137040bad7f53e5c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "916f9fce8f63242f52db7da2e404bd244fe051ab1086d67253710ef0bcb1c83d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc76bacc76f182b38dd19ca95413b74e574c67c670840e425fea1ad7498ed5e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "acf816433214c1e34ef16a114f28d58a8ce6b802e3cb1cc5b1085e32ce53b8be"
    sha256 cellar: :any_skip_relocation, ventura:       "464287f4913e29b37e028b2c79d84289f034b507a459621587903dd8c2ed6c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e055dfce1628933b37d50ca2466c68f6c534670f61d4175d30aa857b90747be2"
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