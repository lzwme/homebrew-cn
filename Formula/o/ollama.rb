class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.6",
      revision: "3a1ed9ff707d1ac4d525e9dfb2a6002c4305bc62"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "610c6841eb4ab95d593a10813ef3562bd6488b261112b45831ac228a77bfbe70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edb4e77bbe25cc75196732cec758487544bcbd9f8fbb0e0653d4c1a15f53f879"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66b800b5cf5a08767013084234141b062cc6be39347bf5d4dd13ce277cc0bfa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fc5854abb5130d9a8de27d130bc6f1ec82bf78258e61fa99fee6f104fcb1f96"
    sha256 cellar: :any_skip_relocation, ventura:        "afe3380f8fcefac5aaa28374892507033bc086bb22f81766592031989763987a"
    sha256 cellar: :any_skip_relocation, monterey:       "5e42039dcfefc95b338c0d9ba187d1cf2f8edb2c9952ef23d39149f0e7ae9325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1ac0cfc78088b3b8213617b48ec14e80483806f913e76bfad8756419757f312"
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