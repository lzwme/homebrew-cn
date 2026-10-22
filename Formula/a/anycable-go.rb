class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://anycable.io"
  url "https://ghfast.top/https://github.com/anycable/anycable/archive/refs/tags/v1.6.20.tar.gz"
  sha256 "d03981135c87401e298b5e79bcad0571e2887db9b946d22fd44f13c24b56fc05"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bbff3113f6d5eea2cdcf132bad61ac7d2f35061dd297af5d60a29f2d3ec3061"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0bbff3113f6d5eea2cdcf132bad61ac7d2f35061dd297af5d60a29f2d3ec3061"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bbff3113f6d5eea2cdcf132bad61ac7d2f35061dd297af5d60a29f2d3ec3061"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "45f0197c4860167ee3547015571717172287faeec59aa2bf2ea6a7f4c5b4e2c3"
    sha256 cellar: :any,                 x86_64_linux:      "421f7da28f3fe54e23afa94c9d8ca01e25b9eb95bba3acb3882b3d823143a627"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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