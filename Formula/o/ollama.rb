class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.ai"
  url "https:github.comjmorgancaollama.git",
      tag:      "v0.1.20",
      revision: "ab6be852c77064d7abeffb0b03c096aab90e95fe"
  license "MIT"
  head "https:github.comjmorgancaollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ceac3a49102235e324362afe4a3ec9c49666cf81dedb8c3c30b7c1e97cee901"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "824e438cc298c10444a991d82954c17dea9a489dcc763677d9262a2bfe45dacb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7c716267c651562e5697c23c3dcdae7e795a376f5ba2a8fc9e91c14d5eef467"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f97d08255f3be637580ac45e390261209dac9db5cc1586a884c08ae086293d8"
    sha256 cellar: :any_skip_relocation, ventura:        "df788135e61f89e50d2e4d476c4a6c396dcef3cae06857a2250ea9af2ede1642"
    sha256 cellar: :any_skip_relocation, monterey:       "a03ebe0e3bdd41eb2d0e6289b0a9770c68f5c422c52b6597bddb0adb94708876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9179cd31b74c02002a5d3edc0998185e2f0908186e76d52395ad7c86808938d"
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