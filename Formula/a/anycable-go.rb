class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://anycable.io"
  url "https://ghfast.top/https://github.com/anycable/anycable/archive/refs/tags/v1.6.17.tar.gz"
  sha256 "40475c64496b4fcbf4dced51c563d1827fd3904c4993ace33a926ba8910b8594"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "342fb1dbba39be816992caa3d429a1f434854baed5642c137a94eb544abe7435"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "342fb1dbba39be816992caa3d429a1f434854baed5642c137a94eb544abe7435"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "342fb1dbba39be816992caa3d429a1f434854baed5642c137a94eb544abe7435"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7ba2a3e68dd7a83e66e8358e645f608e29fdbdf3e7d85391ab9039a2de411581"
    sha256 cellar: :any,                 x86_64_linux:      "c389371d9ce151bc8c744ad4f8a06d72d79f30885761d806bf1c90402e748604"
  end

  depends_on "go" => :build

  def install
    ldflags = if build.head?
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
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end