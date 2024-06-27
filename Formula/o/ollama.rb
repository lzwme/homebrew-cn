class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.46",
      revision: "cb42e607c5cf4d439ad4d5a93ed13c7d6a09fc34"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc81d74842566da4d22cc454d56fd11d1e6765ca243936a31e064145b3bab996"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5262c08c2c289aa090b47d2d30fdf186ee35ae204585405e52c9e441519f096"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f034043cb411968ec6d434738a4c99b0e3dbf6d1cdb35b22eb7eafe0b0388e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c37bffea513c3276a17ff6d122694dd1fae2e774f0441f1326c4a3fac43e01b"
    sha256 cellar: :any_skip_relocation, ventura:        "cf72d60bab630d2edd58e40f741c9e4e1ef152a187673bace5597654c555a464"
    sha256 cellar: :any_skip_relocation, monterey:       "d20f443329568444d0836c6e59ef7d051cb6ec2fda5e12007dbaa3c1a1ce97dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "474eb8ff9f6abf2e2b388b07a8b4bc53994d25b0ebfbb7b1fdefc80c0fa7775a"
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