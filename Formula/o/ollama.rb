class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.2.1",
      revision: "e4ff73297db2f53f1ea4b603df5670c5bde6a944"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ee96f25182e7a732986d361afbc8cf23087c7a8cb9fdaec35953d70ebc7f246"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe85c8f10f177a223eaafe5dea759ff0bb944430e61a5fd10a023a39803ae65d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b00d26ae92e108dc44845b857676eaab84a3d7ce3ba08cf02e39722bb158994"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9fe31c6192be0017a8f040eadd8b55d0545325dbf20c79cfb9e01c25a37ce90"
    sha256 cellar: :any_skip_relocation, ventura:        "7d04884da60552334082ab11640bfe9e3bc8cddacd824e10988ccbc27359fe0b"
    sha256 cellar: :any_skip_relocation, monterey:       "a76f9260fca185255f01d45091a7e02bef201284ae92f5bf58f45d368451c861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aafe8e360e486a46feb00b91d6156a69c83d246cec9e71b0798c652bfd2d9de"
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