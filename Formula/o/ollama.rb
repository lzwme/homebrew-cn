class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.4.6",
      revision: "ce7455a8e1045ae12c5eaa9dc5bb5bdc84a098dc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "225d5717aa77bd4f30e60fcd002ba15eff097f08c2efea1b61dd705f1ecd13fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a07851aadd475d4c7716d8f44ca57fe4ff9b7b3e9b29a7e67e55fb2d32f4d1b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e470282c639fd6936266e31763df1a5d333f4d337c22d33279ee11f599ff054a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea397ff9c7bd4e81217abeea2f825ab6cce8c60364b84bd53cd983e84700b061"
    sha256 cellar: :any_skip_relocation, ventura:       "9b8b0d070bec82ebd69ef6c40934f4f191e422e449c2351f5e83c8550472b753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c62b5e8cf512be65c45d8a13cf3024f3efe5482652667ef483977366a06d919"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

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