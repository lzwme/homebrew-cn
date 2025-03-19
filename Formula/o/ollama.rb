class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.6.2",
      revision: "021dcf089d77292976ee7655eca424dd0b53b8f4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "551098276182564ab2fc503043753128a637386ce1e2bdb048f7401a7163a008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c54c5712e3a064a0863fd5e8a0658e4166c7e1522505e39eb5248b7623f32a81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2a13520399899def305661c98c64572b0fee9150ad064dccea3de68b8521e22"
    sha256 cellar: :any_skip_relocation, sonoma:        "f11d1296a642da92b289233be5e912638431659e6ddb65c9d6c5d14cb7d59ad5"
    sha256 cellar: :any_skip_relocation, ventura:       "97e28ae060d0faea0f0c1739dd5d992621e7032a41fa61580ec10da8f556933e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39db7b60757853fc6bc68ef1c72b546c011216db2f10c6a1b16c11d96c86bf28"
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