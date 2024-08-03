class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.3.3",
      revision: "ce1fb4447efc9958dcf279f7eb2ae6941bec1220"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6348a933ec3a3f210d7fbbb300b62239ffd93d8a44ccbcc19b5f4f1fd8f65ebd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3711ab5bd0b4f38017ed150908d1c102e39e69b52105bfb1b3a107b39a3f287a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b541c4c75c7dcd96adb875acccc1825a4c644961552724b3cc18b5a34347b004"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e4d500a0e4be1907af0a25a6fa051ce8bb9c0956cf215de9f98682504ff054f"
    sha256 cellar: :any_skip_relocation, ventura:        "5af87cdd4608b99c753307a6e0a8b6085b674fcbd2eae286abb422e502b2bfae"
    sha256 cellar: :any_skip_relocation, monterey:       "e23698df15ed2de48a7c74619650056b2a030d859ebc99eb747ef57d632948c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3377000216371509fe3c6256a594d803dd818ac22287e5398bac7c2af59c0248"
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

    pid = fork { exec bin"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end