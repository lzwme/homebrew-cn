class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://ghproxy.com/https://github.com/anycable/anycable-go/archive/v1.4.2.tar.gz"
  sha256 "8407b0e6eefa5ba0a114a6da450f4987def47da26fd2775e5c55be0b5e594df0"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa7148ee4cf1dacee8ad4ee9ee700915aa0133d5dda23743f0712e5159043180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa7148ee4cf1dacee8ad4ee9ee700915aa0133d5dda23743f0712e5159043180"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa7148ee4cf1dacee8ad4ee9ee700915aa0133d5dda23743f0712e5159043180"
    sha256 cellar: :any_skip_relocation, ventura:        "283e6a8d7bef044b556986c6f96f2d12146a4e8dd6ce9218faf4c8984878048e"
    sha256 cellar: :any_skip_relocation, monterey:       "283e6a8d7bef044b556986c6f96f2d12146a4e8dd6ce9218faf4c8984878048e"
    sha256 cellar: :any_skip_relocation, big_sur:        "283e6a8d7bef044b556986c6f96f2d12146a4e8dd6ce9218faf4c8984878048e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a04770b59983082f1caea8c86da60aaecfd0f08532d054e526737e8c40aa6555"
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