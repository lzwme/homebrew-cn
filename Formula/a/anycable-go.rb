class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://ghfast.top/https://github.com/anycable/anycable/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "0af41d2c7e196611d3d4da9c5f37e044f49e73f6117df5559b1c59d812f3e18f"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "069768ead769f2c8d0aad1da61169eb4aba503323295996b4fb0e23c2b3e0895"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "069768ead769f2c8d0aad1da61169eb4aba503323295996b4fb0e23c2b3e0895"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "069768ead769f2c8d0aad1da61169eb4aba503323295996b4fb0e23c2b3e0895"
    sha256 cellar: :any_skip_relocation, sonoma:        "384203a4e86860d9c77000c6d1f1bfaf84a535a6e7c17db9c1cd9e46c922ac82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f677d4890764324e87b09225652e1b8977f30d541a017edfd59b5b648e043f0f"
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
    pid = fork do
      exec "#{bin}/anycable-go --port=#{port}"
    end
    sleep 1
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end