class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.48",
      revision: "717f7229eb4f9220d4070aae617923950643d327"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b820f225166e9762ae06873b98b6c9a8902aac1058528541068dbe33fa2e50c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "302117afc8b3ffd2de325a69621bf0e22d8f9180b92c2f0bb303f929114aa78b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecf17ee9db3e1a0173a4ddd4e69d8fbd745483059db2582fae57f52e8b9fff2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f13329d01edd01513f7c5c3c3377b80bf74f41c8c0e37e45a8f3317e9b139d5c"
    sha256 cellar: :any_skip_relocation, ventura:        "55c1fc1a3696c2d90db7556b5d1f0da8fb05d3841db597a8e0a6704c21ee8aa8"
    sha256 cellar: :any_skip_relocation, monterey:       "774e86ba0c053fe531dff8c571286763d39a9e6bcb095b833134f62dbf6da310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "100f2aadc660e8f036cc879e0ad60974a2657cfebd2f913edc4c868fd3bd35c3"
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