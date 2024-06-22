class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.45",
      revision: "e01e535cbbb92e0d9645bd726e259e7d8a6c7598"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53feda730c32951aa38695d16d589ade081cbf0670b0f5e3cd1c06444b66c4ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f765ce3eb0482c0d68fa58a10186f69008081a82f65f723dee946e5874110912"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "537798dd4fcc7b6829186a94d576de66b29e2e3a19feef8fd6e3f65f382624ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "42fcee519c8aec5720362e3c8bcfbdf18b1d1dc5719689ce703bf30b58118d98"
    sha256 cellar: :any_skip_relocation, ventura:        "a6c33f4339b420e906d5887645c67cab6d16a1488fe9164895a7816c5bc51a6b"
    sha256 cellar: :any_skip_relocation, monterey:       "095448546b06f5abc5ecd6e110386fadc733d75fb6b4f2122b511a4f50182233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2568b7862e7b578574a330f2e03ca619042ff7838a49e4b1cbb88100eb12f695"
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