class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.33",
      revision: "9164b0161bcb24e543cba835a8863b80af2c0c21"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "557674ec385fa5bc4c88d6a2586bc58750ea9b4ee7cd5c0843271c8c3e4540e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32515913f3f5c43e209d23cc2a70a6d8e77b780670838f5b5d1634e5a635b530"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68bdf8178e839f33ec2309a18e417d07861e507a6145d05697b6168551b6cbab"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f43a5077f832627c8bcb3a9bd3d15b29de626ea07f73e4191a28cb027075201"
    sha256 cellar: :any_skip_relocation, ventura:        "0f499af27f2c3b6d56a33838b289de4fe02824343d5ac7f8989669a9dfcda19b"
    sha256 cellar: :any_skip_relocation, monterey:       "970c43220233e5bf1462bc0afac40e62ace3ded089bf48ba652bf6d58864e998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccbd4208251db4d1ecc8423f08b7967fb35501faa13242280d886885280f65a1"
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