class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.30",
      revision: "756c2575535641f1b96d94b4214941b90f4c30c7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c96708580c66ac97bc06c70d042394632c660fdfdf0b7774a90d379cfe7dce3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c541d83920b937dd52132d13e61fc5cdaa944708041d895225c068d721ff2bf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d427b5a4fa85a29d5149f0099856b781bba761981b10b2da48d9ca070b6e191"
    sha256 cellar: :any_skip_relocation, sonoma:         "40ff7c468e4d68891f6fa11e5294b60b8d5b0b9de3e1dc4a74cb0635cd82afb1"
    sha256 cellar: :any_skip_relocation, ventura:        "1a312fef3d7e1b65d56ec7ff37b82278834f283a0394bfd8e62d77ba2fe757a7"
    sha256 cellar: :any_skip_relocation, monterey:       "22da0528f08af2fd41ada4045e8d3e7711f7d85f49e1aaaba7d56a72118ee2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eb1d2a8454732e1b4f33c83aa2a215f04a9ea44845579ee279e1b509fa85e66"
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
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end