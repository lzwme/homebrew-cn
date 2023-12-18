class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https:github.comanycableanycable-go"
  url "https:github.comanycableanycable-goarchiverefstagsv1.4.7.tar.gz"
  sha256 "5ba4216a36c968345b63ea99ece3a34c9b8c95c7427e37bb290a80b1f6f70edc"
  license "MIT"
  head "https:github.comanycableanycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4e2411467e52b4fb28d9577620066256b45b7668fb97067d5af6e7230a413eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dfef39e3e35cf0c3fdc7b109776ca098b764ee06f125a997421275008dbcdb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6a25e0dad320873e3ae344096ba707b2965eea408f9897e8b9b4628f7597920"
    sha256 cellar: :any_skip_relocation, sonoma:         "446823cfb626c109a301a9280d42c98eaa22920ebcb23403997dfe6e105ecaed"
    sha256 cellar: :any_skip_relocation, ventura:        "92bd4be8a0d05e3aa66ed64758f82cb24242734b18fcf0ce3c91ba91ad054ed0"
    sha256 cellar: :any_skip_relocation, monterey:       "76eaf86ec3e95840be89fdd5b54f7a96175a731382d9af8d537d7f3d7fe612f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fcb2e60ca5584a00fc75449c5601f9f989dffea808e90683e91ff0ed1cba0d9"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.comanycableanycable-goutils.sha=#{version.commit}"
    else
      "-X github.comanycableanycable-goutils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdanycable-go"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}anycable-go --port=#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http:localhost:#{port}health")
    assert_match(200 OKm, output)
  ensure
    Process.kill("HUP", pid)
  end
end