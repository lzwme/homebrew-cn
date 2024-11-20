class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.27.19.tar.gz"
  sha256 "e1653a02e61d6608325998b9e4182fd71729a0b3b9c4d8c6c3a25a5c60328f98"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f309abffbca1ea419c51ad87505a7a08dd2f5ecf16dcd4315ea1b996cea4cdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2af958962e570ee341f61c2db4b9fb6f48530a4eabdde48da5cbc64dbc33f3f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dff08bc6ebf9c891b3c6bdbef4541d23b8a002c19cccbf0a1a507153b40f2dd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0c4c2347b5c85b0e4fbdaa3f42f4e73d6ec410cb65b96efa1d4aaf1bd3d3b2d"
    sha256 cellar: :any_skip_relocation, ventura:       "4b2a473b64c4d18f3e0a5866229827e3f2dfaa36167f3b648e12a1361e9ea3f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a1b3fc7047e3c04ed50777011971fece72a07ad55a712b2386266ea3d0ff0ac"
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