class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.3.1",
      revision: "5d6657835669064fa9658e6712b01887a072c606"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5daf5a381433102fd616b47eaa2a3be3542a9e854cea8d18c1299143f7920dad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55387a3b830a3b35f06b7627ba24f0a1b01fe4ebf5ec1186477b8cea3a90aae2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bed9540dea75f8b92327355b828c740923f172b6c165e13a61c298c4a29da38"
    sha256 cellar: :any_skip_relocation, sonoma:         "37b0113bdf102992082b9948675d7cc1e3312ba913ac78b2e1550a43a5e82be8"
    sha256 cellar: :any_skip_relocation, ventura:        "6b656cc60a3571cea53653f83766c1fcfa539e8394e8df3f7dd91ec4d23f153b"
    sha256 cellar: :any_skip_relocation, monterey:       "0340acdcdf0afaf6f61ae3897f77b3fcd70c84afcb312023e8a10691ba33042a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ccd1838a57a5097868f91729779eedf0921f739a4a8eabcaf3bdc88b589eab"
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