class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https:github.comanycableanycable-go"
  url "https:github.comanycableanycable-goarchiverefstagsv1.5.0.tar.gz"
  sha256 "1eae15ba108d24b206e8a9f3cbf53728d2b28cbe2cd38568c0eb4d213b00fbbd"
  license "MIT"
  head "https:github.comanycableanycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1895eb9444292bed70daddb6a501018a083834a81c55a35a4bf1811805c797f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e69d9c18af4219a2b7245a9cc1b39fb2c6b855087e48babeb199df7ddd293aac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf9a3830ecf743cb642e28e0e0d2c52f9834383dcf7ea81364ff800dc88b31f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4e27f64ec15f92a68f6e66ae5c6fd17367b126dfe344b299d030fd4b12174db"
    sha256 cellar: :any_skip_relocation, ventura:        "c349da3ce2f5f2fbff5972988a1728c77f075df2a844eafd0a7af97ed090d5b0"
    sha256 cellar: :any_skip_relocation, monterey:       "aab77fb2a317ffb4e1f63cc2f95afd96ddf178a5345fe9b6410786ee05912fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3406c9dd2e0fec8e511edf7a6724046122ae66523906cf920c6b20cbcb8cd0cf"
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