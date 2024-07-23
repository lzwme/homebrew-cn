class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https:github.comhashicorpterraform-ls"
  url "https:github.comhashicorpterraform-lsarchiverefstagsv0.34.1.tar.gz"
  sha256 "7d677141fdcc20675d6c5fa7666a463d881424bd1c7bc346549f61e33bdc94f1"
  license "MPL-2.0"
  head "https:github.comhashicorpterraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b603f1325484a0398ade458f463311631e3f7a44424f9750a7fced5a9e5d162"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19b8986966d85b9ed8cb9651ba0135915183f01fefbd4cedf22b3823307f0e80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eac6b28ae180288b29ae09fd0217fbfd02ea6ec8f41f6b982561bad9581ca9dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae77f1d7ffcb11a5463b491963ac83b611bf2047d3f7e955b17bfb1ec3bce3c0"
    sha256 cellar: :any_skip_relocation, ventura:        "0b403192a0b3dc009d16999c61dfb842e7dd3ada0314424a4b4fb3691585e90d"
    sha256 cellar: :any_skip_relocation, monterey:       "bfdbbc02838086e40041d86ea6c3425020c7a01a5800698e22768a2ef5ec7033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f53924ba842c11c72ac3459f6102c5ab33fa226e2682810f43eb99f79abe53f0"
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