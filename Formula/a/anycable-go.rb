class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://ghfast.top/https://github.com/anycable/anycable/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "0a2fe782197d88f3f523ab7d11159e41a9baba322bd673e98512e4cbca095b77"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a4661e8ad1063679d8a23a854cde0456ad8a1a4c188bdb6a180df6638a84cdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a4661e8ad1063679d8a23a854cde0456ad8a1a4c188bdb6a180df6638a84cdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a4661e8ad1063679d8a23a854cde0456ad8a1a4c188bdb6a180df6638a84cdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8647112f7d8bbd35361f968a9e74802c3bcae1b42ab21e2ef4d4913c044e6427"
    sha256 cellar: :any_skip_relocation, ventura:       "8647112f7d8bbd35361f968a9e74802c3bcae1b42ab21e2ef4d4913c044e6427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f43611a02cc809ab053045504062115ec22bcb58e2a751a1c8782159ecbf52e7"
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
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end