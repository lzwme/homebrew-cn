class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https:github.comhashicorpterraform-ls"
  url "https:github.comhashicorpterraform-lsarchiverefstagsv0.33.3.tar.gz"
  sha256 "6c4af6b4a171a9e8d05774784b1131ffe5c26e0d58874a6378946246259f5620"
  license "MPL-2.0"
  head "https:github.comhashicorpterraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82d0e75c478f1de596f46cd523400b305c32f0fe6decb7e0092b97fe800935ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "813ee4533bdab781a9885e609bf9c85aad416c220c3cd64bce44fd75a2bfff4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32c54c65be03ed203e94763371d0cfa4fd337d75ee923d93a8b09fb5318bbaa3"
    sha256 cellar: :any_skip_relocation, sonoma:         "17a8f6cd5a7a761ed840245858e04f413eac241eb7ad810227130d0e67997213"
    sha256 cellar: :any_skip_relocation, ventura:        "7f39c37538c70e78adb6aacc603856aa69bd6f50bc7861dfd95ead5a29ee8af7"
    sha256 cellar: :any_skip_relocation, monterey:       "d40003b6a3bb5e42c784094dcc666674501eef617a0d3846ad933f920ac67954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f72de420b0cbe22f362fcef6b3cd578f7080db2b1febcae83b560780c11b015b"
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