class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.11",
      revision: "f2113c1fc79110c5f243a39cb5ac03590b67fed9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78de9aff90752dd748aca31e34289d26c11d52db0b93a88f479cfe33336b9604"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b0830b7441a5c9178751f059a6c9c77abf9c648c6437804fa1e3b2e845149b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "090d13e30e44c9a00b1cab429b4e256af6e581423e3a771d6ab0e3545472012b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b94fca9d4a5616ba8b5eff9b5bfe730b26814868e8c577bce4a60f25e314153a"
    sha256 cellar: :any_skip_relocation, ventura:        "b85b74fdc419feff00ba5c2e834b8606735433df92638eacb38562daa221b7e7"
    sha256 cellar: :any_skip_relocation, monterey:       "b39018d386c45898e3cc5e2de7d217a79cb2cdfcd7d7c41c5beb8e4154da103f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70bfe8c93163f6dbd52f7ce6047393e1330d167c766c3d62201904bc06d908f9"
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