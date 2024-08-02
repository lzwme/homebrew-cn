class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.3.2",
      revision: "4c14855ad78cde21862ae5286e18e31a4ae9147a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a03c3cf44343ce24f521e103f03def91fee50f54dc47a67c399ae9fd1f3e7ed7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27072ce9a47c1fdf72e6c5f187abb448dfdb5730878ade3cf6d693eb035bbfd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dda777da09a3496535850f71839b7f235c5dc7c7cc688a812e014b27cd168640"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a09e67988ddffe2e3e5e19c5d9d5468cbf449ee7829850fa1d9d9ce27ed58d4"
    sha256 cellar: :any_skip_relocation, ventura:        "a7d5885627a3bbe31e006e8e12974bb0bf6a06d42eaba097785e7b802b24ee8d"
    sha256 cellar: :any_skip_relocation, monterey:       "02abc50d6468b4e66087029507e9cf4bc39172c7c31952211ded33b8dda2f9eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23ad027dc4390689a48cde85f0f7939bd7f34320b9f9c7fae4506eec413e66b3"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    # Fix "ollama --version"
    inreplace "versionversion.go", var Version string = "[\d.]+", "var Version string = \"#{version}\""

    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags: "-s -w")
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

    pid = fork { exec "#{bin}ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end