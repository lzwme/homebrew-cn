class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.2.4",
      revision: "1ed0aa8feab58a5cbdf2d79fdb718e3a5cc03525"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbe1e0cd2841189f315337252f4c4ee0b999bd2bf9c7592f59229b24e2757a7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86d8380623fedb698cb24349fc2f53c2a0b65f6698c4f546bc834147ac02d30f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "551ea5004eae7c5f6d860fb540424f805771fd6bc15d8e69376b923baafc30a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "699bc755cb779406f2bddae2a376cef11c825074541d65858445f9dae4d69541"
    sha256 cellar: :any_skip_relocation, ventura:        "c12e11c1fce84c8eccdc205db10aab0ea94b26dfc8e0aa4251bec26d1ce54dea"
    sha256 cellar: :any_skip_relocation, monterey:       "62dacb0165fb99396ce97de102cc30b1d01142caf1e7cb634905a79eb497c768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "617eba0d313903282ccaafb619dbc1494d414066ec7782b1b8ace3a87f3def4c"
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