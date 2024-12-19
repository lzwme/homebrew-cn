class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.5.4",
      revision: "2ddc32d5c5386b28062a46ac6cfea5160cd9f600"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eefeff6e27e5e96099dd9f3d8cd266d2e81f6078cc585ef7663adba0e41acbc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6232e03116b867cb605b3c166c6b123f68a257f6328240e4f628acef4867d31c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "907bba80433b445226e6ab50efeaf6ce62d2a17a9e3d0c7b5233748fbe32f69a"
    sha256 cellar: :any_skip_relocation, sonoma:        "432e859e5774aca9cdb4b4b77f1d801b58bbd8d3ce21050e62b817d391135c6d"
    sha256 cellar: :any_skip_relocation, ventura:       "dacdd241bb03c0b0a7f8019a259f4b39b0854af7719c0abe02de093993ef053c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbb63f465f33da3d358d56d6f89d0e622084e4b2bfa1f69013f0ed002fa95a2d"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix to makefile path, should be checked in next release
    # https:github.comollamaollamablob89d5e2f2fd17e03fd7cd5cb2d8f7f27b82e453d7llamallama.go#L3
    inreplace "llamallama.go", "go:generate make -j", "go:generate make -C .. -j"

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