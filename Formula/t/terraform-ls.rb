class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https:github.comhashicorpterraform-ls"
  url "https:github.comhashicorpterraform-lsarchiverefstagsv0.32.5.tar.gz"
  sha256 "de2867c3cf9d86c26563fc8b8b7b2bc936853e37f46eb302e2c6b43f0f5e91f8"
  license "MPL-2.0"
  head "https:github.comhashicorpterraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87b1cbd8c87f63fc160433077c844c22e62425568e151bfb11a8bb34f87716e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73e0750cfe24bd0aea9857c3daf97bf5726182e9fb62c502722e6ec19f17d25c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c3a0a9e1209ef1d454aed47356faa02e92bc8da3ab17725f84f13d45ac86512"
    sha256 cellar: :any_skip_relocation, sonoma:         "85454b39c3d2b92a0dcccb390b2cbeb98e99c16ac91b9613fb5070d5fd997b0a"
    sha256 cellar: :any_skip_relocation, ventura:        "42b1920cd06252a4e03cf4b4f659ced733b81c8a4ab1fe7e011641a06f5b232d"
    sha256 cellar: :any_skip_relocation, monterey:       "218090e53130a5e96b0d002a6fe099e4acee9027cca494ab32dc3cecf689738b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40e85aea5424feab7d8e568de6a671476b3c05139fbab126b1e37c5a7db19de1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.rawVersion=#{version}+#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}terraform-ls serve -port #{port} devnull"
    end
    sleep 2

    begin
      tcp_socket = TCPSocket.new("localhost", port)
      tcp_socket.puts <<~EOF
        Content-Length: 59

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Type", tcp_socket.gets("\n")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end