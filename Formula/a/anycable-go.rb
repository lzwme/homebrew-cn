class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https:github.comanycableanycable-go"
  url "https:github.comanycableanycable-goarchiverefstagsv1.5.5.tar.gz"
  sha256 "624cc97a06bcd92193d8c2a8a24f1e938f3ac7fb52d0a6b3440f61140088d950"
  license "MIT"
  head "https:github.comanycableanycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ea01e906086405d66d5d6525d4e5c04d18e2b025a891f450313fcd95013af31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ea01e906086405d66d5d6525d4e5c04d18e2b025a891f450313fcd95013af31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ea01e906086405d66d5d6525d4e5c04d18e2b025a891f450313fcd95013af31"
    sha256 cellar: :any_skip_relocation, sonoma:        "16ff2106e29c74eb6d51354134d45709fb277792f7e7a0f935932afbb222a5d3"
    sha256 cellar: :any_skip_relocation, ventura:       "16ff2106e29c74eb6d51354134d45709fb277792f7e7a0f935932afbb222a5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcbb1b84ef198f569b530831755f06e89797d4ced6d7796a40bcf2ca77664757"
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

    system "go", "build", *std_go_args(ldflags:), ".cmdanycable-go"
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