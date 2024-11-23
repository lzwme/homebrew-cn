class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.27.20.tar.gz"
  sha256 "4fb49f4de9333e30c14bfbaa1f6fc0bbe1f54e497ee269a88d1a78d2342d76f8"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d22a74803b7a6ae72f34d17f3b5b6d616eb572350fda1f7d91bf6061a74acc0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69724049f9621e9d0463a55182d506914d086518a62fd6545eab8f5423d78b54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc6b7f5ca2174d2079e0ad0e2a4fe3679cc7a71122830540a9875ac85afbe40f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d6a6d6f5f265b09ec41e6311188791e01fbd7b6198697ad34c5a7b1bfad349d"
    sha256 cellar: :any_skip_relocation, ventura:       "ddc2dfca31efc9fce0466ae84631cd49c23f2c031b2f235072981b1916095c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0e0a6bf46ea676102aa27249c8fd3b1bfcb72ad8f4d73685648054093092aa4"
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