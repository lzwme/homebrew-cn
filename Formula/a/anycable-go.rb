class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://anycable.io"
  url "https://ghfast.top/https://github.com/anycable/anycable/archive/refs/tags/v1.6.18.tar.gz"
  sha256 "ec1a43bf16d4009a97f60a813a7da0d74b0949352deba32d479a5db1fdcc11a7"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13c52077cec329df7eb98a7757a560513538786fbe3508d435f601d9c3565e0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13c52077cec329df7eb98a7757a560513538786fbe3508d435f601d9c3565e0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "13c52077cec329df7eb98a7757a560513538786fbe3508d435f601d9c3565e0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "008178e3bf31bcf227d3222bb333db33eb5cde492131b5eaada64eb04d32c2c4"
    sha256 cellar: :any,                 x86_64_linux:      "e9422a99fb5dad8938ef6195b1d1443711d0d40ade8e120c0b31a871a18166e7"
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