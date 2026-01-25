class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.15.0",
      revision: "0209c268bbc82f9001c8a35bcd7b7f4cf20a2263"
  license "MIT"
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d826a174225c0a81db56ab7bb37f3664fff9fcb0c7fc51c44cc96ec386565c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ab57056d5020d316adde89bced6297acce8093f0f1a12ea793ffedfdb7e88bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c6fcece2855a4f478b1b1ca4123b5841ed2a642db3ac7a9bbab67b8f15705cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "55fb2947ee0471ed0a46595a240572a03619c82f4b035133c6691cb7c54edfc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6694d62a64c79b6b2ec1f5c5e30ff9cbfb5ec45390a7a361a5456b3f469644c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb95926f04227def3e8844f5de8aaa8331cfc12bbc11cb6010a665b27ef4eea7"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama-app"

  def install
    # Remove ui app directory
    rm_r("app")

    ENV["CGO_ENABLED"] = "1"

    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X github.com/ollama/ollama/version.Version=#{version}
      -X github.com/ollama/ollama/server.mode=release
    ]

    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = spawn bin/"ollama", "serve"
    begin
      sleep 3
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end