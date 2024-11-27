class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.27.23.tar.gz"
  sha256 "46349b473440f486a04e5142eff20d50066d03c43eceaaa409039ade00ab8ac2"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f80bff38bae18561d4aa866f80cfb7e3b571e3a0f4fec4a839b1b6a5a55a300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b6ea17dd415e89bca960c78cb26a519ffb62b0e6da4f78269f942f0336cb9a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afd45324dabfdc95dd1cef2037717759710847577cc8f980901fca3e4b9148fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "37c6dd218e344c0c0067dc7ad616753cbc7374a9b4cd68ea0dbad0d45e233323"
    sha256 cellar: :any_skip_relocation, ventura:       "32d5c0833c2057ffeeb1dc8f46ce4e2e81273a5fe7d66863f0a9123f6508b0e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11fbea5f82fe600f892eb458f514a157bc5cc40a2d2454226fc1314476937f84"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin"gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output(bin"gollama -h http:localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end