class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.8",
      revision: "e21579a0f1548e2d1f77411af3df2037c1f144fe"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe6e46431c0317b0687915744e1d00262e7a3f778180a1e404578c5a095507a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23289bd6149e51718ab50e17f8dfa0c3911c19726c715d7e74247754edc76ac8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60ed1318b0dc4eccfa8db3e2ae14e1b47f04389e2927b6738fbe44ea641b2f94"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc4d37bc3fa46eb644f11f73817ab225bc20c7f758a05402031f562fe35e0dba"
    sha256 cellar: :any_skip_relocation, ventura:        "37531a19705e27a408e2c6bff9fe8d8be1ebf69721c1a837eadd247f2389c5cb"
    sha256 cellar: :any_skip_relocation, monterey:       "8502d74382e715f60f5a7306a7486eef5cea4006b7ce5dee08482958726ba2fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cc2bec0bea57a621aa87c25a79f0e9c95d1ed66f4333f653ba49a71b1065ca9"
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