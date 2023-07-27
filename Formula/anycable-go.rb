class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://ghproxy.com/https://github.com/anycable/anycable-go/archive/v1.4.1.tar.gz"
  sha256 "3b1bca4a62409c1344d5ad1c40489e1bb2d3fc1bfdb93203642356999290fe96"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a760b375f07db8cf3fd0a73a971136b62f5209c018a91eac6ab55b29fe41efc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a760b375f07db8cf3fd0a73a971136b62f5209c018a91eac6ab55b29fe41efc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a760b375f07db8cf3fd0a73a971136b62f5209c018a91eac6ab55b29fe41efc0"
    sha256 cellar: :any_skip_relocation, ventura:        "767d03cdc6486cf5044b7c8d726f2845615e32812ae393d52b2ffa286c5c970d"
    sha256 cellar: :any_skip_relocation, monterey:       "767d03cdc6486cf5044b7c8d726f2845615e32812ae393d52b2ffa286c5c970d"
    sha256 cellar: :any_skip_relocation, big_sur:        "767d03cdc6486cf5044b7c8d726f2845615e32812ae393d52b2ffa286c5c970d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d82e1facde77ea51c365a9b21b4ca308e7d635518f4123b54d31501ba8db1a2e"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable-go/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable-go/utils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/anycable-go"
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