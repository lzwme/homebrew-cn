class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.26",
      revision: "2a7553ce09cf1ae5a93a290acd5109f2327cd6da"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7851948bcb818b5101a6d3fc876a6017fb8490ff3c7999fe203bf217823d7ccf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cd8626e975e621c193fc146e25cb0c34fe41294470349ed3446bf9c600e145e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc0ff922f514c67b2b1c7d6010c5b81aac9dc71408653e6b768441fc78609f66"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf62182b4def3d2f55bb72348eeaf209f560098ea1d61c97511940fe970b146b"
    sha256 cellar: :any_skip_relocation, ventura:        "fa611d29fa5888d27ff5b97f296a43042837e4f1bf31265c605c91c3d504329a"
    sha256 cellar: :any_skip_relocation, monterey:       "7d004083d7ab49aa898a1598a19c4dc7b575850cb96595badd8c6ec651b7ce13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "648d1fcb1f43c5a0695964b62698063d5cbcd9a977393fe6cf7a5b9cb6b958f2"
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