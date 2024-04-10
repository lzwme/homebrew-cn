class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.31",
      revision: "dc011d16b9ff160c0be3829fc39a43054f0315d0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45a20758a6c42daabf2ac58b357bacebed1507746b788e83b826c18fb00f6dc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a13d1fcc04af4741339142c5d1b62c2fc92dbf7daefbb7eef55ca238bd70054d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d86020a60be658da35fb3126d92a0bf16936ee52151e50948369fe91cc522911"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6cfd5faf394e4273b391bf58e1d3728c1b59d4dd1404c399189aaf0548c3ef5"
    sha256 cellar: :any_skip_relocation, ventura:        "d2795e36863cc157e145e20041060616476fa0b7c8382d563c61f034448f8f71"
    sha256 cellar: :any_skip_relocation, monterey:       "c9cc6c01ca12aa5916adfc101f83a9d5f189f1173b62d0009e7da4d047661b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c98fe3658d830e5c9947d9fd185fe5ed2627c930304cdd7b6f71b04a49d1ef9"
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