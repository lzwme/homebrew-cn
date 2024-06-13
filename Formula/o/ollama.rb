class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.43",
      revision: "217f60c3d95edc7d5dcbeb4c3cffb0190c147f92"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45ab694cab446e14b91366c905c11cb3773bd581f052fa18f8cd54c90ff1ec17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9f9f2e4010f55836f15d1ce874ad1193bd20505e01c58bf48393d02f8de6088"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6477c2abcab163db6d88def26bafd27a1b73e1f9978f04646d42bca779bed0be"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cce9d39497365e9aabcf0bc1228575993106312981aba2524b199386b2d29ce"
    sha256 cellar: :any_skip_relocation, ventura:        "80252a8a375fcd2b236554df428d3f35344cbb736776e56b991300c0af3721cc"
    sha256 cellar: :any_skip_relocation, monterey:       "64cf8f4cd0646de006c43a7009079d2eaabd0cfb0ab09f5aeedb00005ac56c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdc3e996653dd6ece95148a353a9c28855916e518591f34e62de6ceb5a1a8e40"
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