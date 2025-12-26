class Gotun < Formula
  desc "Lightweight HTTP proxy over SSH"
  homepage "https://github.com/Sesame2/gotun"
  url "https://ghfast.top/https://github.com/Sesame2/gotun/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "068bc457d87bb389fe107c8bcf5c132ba372b4700c79d4978e9de6bb8e3d0620"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8bc4070d813f88b617d416aa857350dc0a87b00eca0c3f483e3a0a07af85992"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8bc4070d813f88b617d416aa857350dc0a87b00eca0c3f483e3a0a07af85992"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8bc4070d813f88b617d416aa857350dc0a87b00eca0c3f483e3a0a07af85992"
    sha256 cellar: :any_skip_relocation, sonoma:        "043a8dc7c1b2d8edae0b1bc066dd7cfbf7ccc7837174b90ed15e3d22fedf9496"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23a639c64836c3388aa5a14bb3bdd2722f25d3584a66e5a1fac61d85f517eb7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c1016d55e8e2c944d509f76cc724ee0a2e4e38da3df6f333f73c04f483349e8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gotun"
    generate_completions_from_executable(bin/"gotun", shell_parameter_format: :cobra)
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