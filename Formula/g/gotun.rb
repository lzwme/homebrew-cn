class Gotun < Formula
  desc "Lightweight HTTP proxy over SSH"
  homepage "https://github.com/Sesame2/gotun"
  url "https://ghfast.top/https://github.com/Sesame2/gotun/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "068bc457d87bb389fe107c8bcf5c132ba372b4700c79d4978e9de6bb8e3d0620"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bcf437b8bad68fbd4a99c5bfadac03bde329a346b3bedcc529e69499f135c77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bcf437b8bad68fbd4a99c5bfadac03bde329a346b3bedcc529e69499f135c77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bcf437b8bad68fbd4a99c5bfadac03bde329a346b3bedcc529e69499f135c77"
    sha256 cellar: :any_skip_relocation, sonoma:        "68aa1ae0851c6122f9a2b3a073cb9023276b7c098d0559151375b8f0551869ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bf22d6d937a3f19186e1aebe7007371cc7e5f588798e1b06416b1c35989fb11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d51f705ebbd925d58bebdc5dc3de337668c33661bf33746f73ed175770acdb1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gotun"
    generate_completions_from_executable(bin/"gotun", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotun --version")

    port = free_port
    server = TCPServer.new(port)
    server_pid = fork do
      msg = server.accept.gets
      server.close
      assert_match "SSH", msg
    end

    require "pty"
    r, _, pid = PTY.spawn bin/"gotun", "anonymous@localhost", "-p", port.to_s, "--timeout", "1s"
    sleep 1
    Process.kill "TERM", pid

    output = ""
    begin
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    assert_match "GoTun dev", output
    assert_match "localhost:#{port}", output
  ensure
    Process.kill "TERM", server_pid
    Process.wait server_pid
    Process.wait pid
  end
end