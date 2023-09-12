class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.0.19",
      revision: "45ac07cd025f9d1e84917db3f00e0f3e5651aede"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c28605511527744c3ab620cac100eb06b37cc61a2ae25787cceb39a3e5453a4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76a75f39312e93533fc994a4834c81b8eb299a0112c2581f7cdbd543588d8732"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f0a925eb20550fc7692e265098b041d1ce1a48ae33a8f5fca280043f0b536db"
    sha256 cellar: :any_skip_relocation, ventura:        "20ba83604dadb1d87737b2268c33e27a6cf2115d3412c06ba2db3ae12488cbeb"
    sha256 cellar: :any_skip_relocation, monterey:       "4db836410137eabb475fa8c57e9b8a2e814c28a1e51d0c98694b232bac215745"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1df20f8318a30f2ad5ff6262d8a0c754d08670b36af281a5462e26c16c3da8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a5f4499beb3e41c73d758346921342f87443581059870a224cb01e22b6bc62"
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
    ENV["OLLAMA_HOST"] = "localhost"
    ENV["OLLAMA_PORT"] = port.to_s

    pid = fork { exec "#{bin}/ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end