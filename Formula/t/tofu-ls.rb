class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://opentofu.org"
  url "https://ghfast.top/https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "05f75c17c164c48c0b65a0d0f727dbd7cb921560c23a9bff3c4db4a2a847519c"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ffdb4125761b437a7fe5ba99c0f1b18e49e640210a41fa9b2deb7bbb1874587"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ffdb4125761b437a7fe5ba99c0f1b18e49e640210a41fa9b2deb7bbb1874587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ffdb4125761b437a7fe5ba99c0f1b18e49e640210a41fa9b2deb7bbb1874587"
    sha256 cellar: :any_skip_relocation, sonoma:        "75d1fa044bfc2ccea9027d5121366c70db92e9f6fbda29b6ccec2fbc2aa8a5c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5667421aa5a060b9ea16db9f286cf9d5330536ac0c0257a7bf12ecf48b05d7c"
    sha256 cellar: :any,                 x86_64_linux:  "4f1ee0943fd00c465384b6d3625f3cdd5c96c158748e6617a8d17ec71439693e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.rawVersion=#{version}+#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    port = free_port

    pid = spawn bin/"tofu-ls", "serve", "-port", port.to_s, File::NULL
    begin
      sleep 2
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