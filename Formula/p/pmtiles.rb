class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.25.3.tar.gz"
  sha256 "2e4aa3a475015d834dc18e1726054bf73a32adaeaa46ce250cedcd60ff1aed01"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c9b6138d803ab3b74630999c9aca304723dd21bd6295e04a902c68cfab19cc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c9b6138d803ab3b74630999c9aca304723dd21bd6295e04a902c68cfab19cc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c9b6138d803ab3b74630999c9aca304723dd21bd6295e04a902c68cfab19cc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfaf8931111ed77cfda73f4a2a333a61cac89fa9792cd015620ad3e8130b367a"
    sha256 cellar: :any_skip_relocation, ventura:       "bfaf8931111ed77cfda73f4a2a333a61cac89fa9792cd015620ad3e8130b367a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fe05f21c8ebc0600b97a1530a8258a0509c0743a09703ab39196561ff086117"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port

    pid = fork do
      exec bin"pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http:localhost:#{port}")
    assert_match "HTTP1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end