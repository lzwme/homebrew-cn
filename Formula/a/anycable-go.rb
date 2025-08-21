class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://ghfast.top/https://github.com/anycable/anycable/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "469d6b3ab79c14532615c47f613211dd0d842183088f62df6ee0e2e01faf5904"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce371d32227cf5ff87786fc25b581e12d738e8496788526e7421fae3deb49de9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce371d32227cf5ff87786fc25b581e12d738e8496788526e7421fae3deb49de9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce371d32227cf5ff87786fc25b581e12d738e8496788526e7421fae3deb49de9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3be49e45d329b02fa55de39adaef931813c5b7785458b8901698ea01c4ecb8c"
    sha256 cellar: :any_skip_relocation, ventura:       "a3be49e45d329b02fa55de39adaef931813c5b7785458b8901698ea01c4ecb8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0baff7cd89887625f2f935dd0894ce8605d5b11e37e1349cf5eed3abe29338f9"
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