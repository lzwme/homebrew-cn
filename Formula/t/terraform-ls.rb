class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https:github.comhashicorpterraform-ls"
  url "https:github.comhashicorpterraform-lsarchiverefstagsv0.36.2.tar.gz"
  sha256 "039c342922325ddd9711298a61056c2577abc6bcdbc98e16e49fbd8775cc7a00"
  license "MPL-2.0"
  head "https:github.comhashicorpterraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a7c74dfcca86ea804d55ab226f9af2ff7c7a8d0f268785705d6c24e36191763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a7c74dfcca86ea804d55ab226f9af2ff7c7a8d0f268785705d6c24e36191763"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a7c74dfcca86ea804d55ab226f9af2ff7c7a8d0f268785705d6c24e36191763"
    sha256 cellar: :any_skip_relocation, sonoma:        "df851be0f2a2aac03e4a13bd0ed1dc75d36ec9b3577e69e951f92a1821ce9740"
    sha256 cellar: :any_skip_relocation, ventura:       "df851be0f2a2aac03e4a13bd0ed1dc75d36ec9b3577e69e951f92a1821ce9740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d9960702675eb5775a36b74b677b9d690419ab8e81e4574aff1b69fbd4e93b3"
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