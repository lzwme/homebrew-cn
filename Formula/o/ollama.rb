class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.10",
      revision: "41434a7cdcf33918ae2d37eb23d819ef7361e843"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "308b7ef678eb0a41eed7aa2e10fcaaa785cfeb11a5f9e9376ab211a3e87db5eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf2e890e4612d7352770c3d7811630d6ebdb7f0a631ba7b14ff35dd64de16c3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b30c30606baf24fe2d69a57e46217276adb0fae42b980c4480330256552ac6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b44fdb20eb66cecf02d07d7c5dff0405df476d928a23b190ef7721f27a23f5c"
    sha256 cellar: :any_skip_relocation, ventura:        "ba3fa6ad596070f84ace8418e23c7f62ababe4549e54853418cb066eefb5f8ea"
    sha256 cellar: :any_skip_relocation, monterey:       "79e9d20cb25789c01fbaa439cc77c9fc5740685ef3edf71d06b9ade3fd2d33d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d5b5d6ba6c8a90cebc5377b8afed64ca47784f4fe18a4a47ab3ca3694503223"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build on big sur by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :big_sur
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{bin}/ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end