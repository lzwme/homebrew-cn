class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.39",
      revision: "ad897080a299bf86aee16b498edb5ddb250edd35"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4656a8a23de070a6907ad0c69139ca99ed636e082e8c7a48832fba1bae61df2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bf3421c455e0527e7db1009f286d12936208f0ac3ae2911ce4777252503c6d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "863fdc3e478111657ce2c2f7da862fb07f2c387b972949aa925eb3effca30953"
    sha256 cellar: :any_skip_relocation, sonoma:         "be5cd1f3caa63e15a6abab5fa5a6180b0f658d0f91fdeb3573addebb0de0cb59"
    sha256 cellar: :any_skip_relocation, ventura:        "5e67002556a8d606020f0673c6d01ab1aa45357974a91f18aeec86ba5d1ec795"
    sha256 cellar: :any_skip_relocation, monterey:       "0402a25128a459d1710d3501b838a5a8bf06d7ce0a6c823177078dd80ccb443a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cebef51c7c345ec5ae1a604be89e2b5b7072e7ca928e6307b75a2cd4c3e7b30"
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