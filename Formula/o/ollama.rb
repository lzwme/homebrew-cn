class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.13",
      revision: "cedae0d17a38a23269191bf69f2b2248aa830303"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc29231045dc6b8674a626a0bfbdb6b26a03305f46a232abf371e020f5b2268b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c0b4ec26fc7795f8d7f0c7ae1ad2b0d7fc28ad211349cb17fa497f724ec1c71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56bdaeb93c777147501c9845e5873b118a8efed11d04e68dbbeecd96e1302825"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bb8f4e7d77e0437563a07d6af3bf7e5f37619273b38bb7e79d0899b58d16ef8"
    sha256 cellar: :any_skip_relocation, ventura:        "cdaa28c235df4e6fb1d54676934cb2b0a05e8120864c95d77f32545f5d458385"
    sha256 cellar: :any_skip_relocation, monterey:       "9862a5f5ff939da30ed2307a9e091c61baae3796e91f8da630264dd5d5a553e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5069a8386454121a882428cedf561dfc149d828a4d30d09660397c782ffd192"
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