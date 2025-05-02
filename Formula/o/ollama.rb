class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.6.7",
      revision: "a7835c671615d71280ca7dba7264bd05a4f90915"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee557c3278f175a1ec8efcdf37299f89c740205132be45e384e8e21dbdb3347b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdea24fe8d2869596091d2898d30c0e64991ebf3edec1f05248808f88e34ccdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a880d72db8a72d142cb687b6d21e2eecddb51eecd5acfe71d748c69bbe5151e"
    sha256 cellar: :any_skip_relocation, sonoma:        "adff6b05f98c25aa4d74cdde8017186bdb471991040410d3a9338a95a38f4a13"
    sha256 cellar: :any_skip_relocation, ventura:       "85f4205caa445924cc38edd171f7d051698fb2059b27c1e29ac55057b4d1db05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f15572dfe0f96ef51db4ad8a3068802bf70fc7c28cba59aafb68e8c760efdb3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ab0fed2cc8357a1fdfea7c1a9d0efcecac267f00286b0aa6eaec46eebd8167"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama"

  def install
    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X=github.comollamaollamaversion.Version=#{version}
      -X=github.comollamaollamaserver.mode=release
    ]

    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags:)
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