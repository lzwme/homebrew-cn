class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.2.5",
      revision: "f7ee0123008dbdb3fd5954438d12196951b58b78"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8416f1f893e37cdd01d090f561abc4715cb6e6626b6591325c1576f81f7994b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ce4fe78c2e12a7111bad0932ffc023bf9112c04dd483efcc04a57162552e225"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58b36e2e73014509d3476c4a72ab002b9d6924d6304f13bfcb938d8cb9563df6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6393a449012147596c94c3c4a9f965967bf733753f592031f263fc6432be2fd6"
    sha256 cellar: :any_skip_relocation, ventura:        "58b64d7684dad384ad285c916a91926df5d879d0c0a15c6898254957ec73dfc6"
    sha256 cellar: :any_skip_relocation, monterey:       "c1e8c1b58eba36d65eaff43b942506a3e29b272a7805dabb0d57acec90fb400a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbc2f99d40b6da87fa05499bce72e6a7375ae61fabc70b2995567ad4899fceaf"
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