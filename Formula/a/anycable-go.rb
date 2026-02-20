class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://ghfast.top/https://github.com/anycable/anycable/archive/refs/tags/v1.6.10.tar.gz"
  sha256 "5eebc3dcd5e4045a51bcd981ae59c438afc794f497566df8498186b4eee5f5e6"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e8d1dbceea271aa09a54613e655b4ef00d6ade3e63c6454a353f8891814c333"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e8d1dbceea271aa09a54613e655b4ef00d6ade3e63c6454a353f8891814c333"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e8d1dbceea271aa09a54613e655b4ef00d6ade3e63c6454a353f8891814c333"
    sha256 cellar: :any_skip_relocation, sonoma:        "d966016d3e4fc8d66ff08b83ad582ab4029d2846de23217a55950e1a9d782931"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40226e093f9e14eca00b4edf821514a0abd8783117901d81898ebf1216cee7eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bba97fac22281c7352404a3b6bff28c56deab5e70174ad4c5c98fc0877d053a"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable/utils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags:), "./cmd/anycable-go"
  end

  test do
    port = free_port
    pid = spawn bin/"anycable-go", "--port=#{port}"
    sleep 1
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end