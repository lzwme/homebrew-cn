class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.ai"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.22",
      revision: "a47d8b2557259ffc9881817df97fbf6d6824e89e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0720011eca38539fe580fadcdd2cb20ce7f3904ba5454f7eed898da6dbdbbd9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44366ec3f713ea4cc0a9743b2feb424df81476a099746fff2f9ff43101bd35ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b8dadcc7d7b7e723d45896fed7ae3b684ca7b6f3a798996a61bfd8080de184d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b157077a62c20785cb4b5c73e98231392e53e7287f8fb3c130da2e8f44860573"
    sha256 cellar: :any_skip_relocation, ventura:        "b3dba4d118e433bc05d0f94fd9ecc3f3d53907b8546427107efa672a502c76ae"
    sha256 cellar: :any_skip_relocation, monterey:       "ffddb9679a3f848a414fba3921bf6f44607dd0022f9517b4fa2469835d794c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3835310ede039dfeaa2d1bdeee751b235e1e76adfe8e8208f19f67385728ba9"
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