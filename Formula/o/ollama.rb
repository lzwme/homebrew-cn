class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.9",
      revision: "5cba29b9d666854706a194805c9d66518fe77545"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67b5292af720398c8adc3a8783db9a0e1c74aa402da543dccc1bc889f36e4b07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10126ce5346a2eb4b4b5b02f8fb9e9ce6b4b703f4c7883ab7ed21ab5a88e7e24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2567cc48c6aaed9276f5ca1a718b99ae4c835e813c1380a6f858b1107b7b2480"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbaaf87e01f4e86413eec6b32bbf9c232a31403d6ad7a8b961ebfa9187386998"
    sha256 cellar: :any_skip_relocation, ventura:        "490866e1b4ab400c610f6eb7ff070a8e7bcc68acf1920f8c486ae962bc089dd4"
    sha256 cellar: :any_skip_relocation, monterey:       "3fc9fcae6fa2e314257c60074c36cbd66377bb56586ca24667a233e9da2b12e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a0fece990e5a0089fbd05eb584ac3a400f53b51dd8a8755d5f4abcf60b69bc8"
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