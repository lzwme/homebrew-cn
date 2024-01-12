class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.12.0.tar.gz"
  sha256 "22b1c5ed5a64e632d2414acf13504b840a2bffe130fe15ffdc460fc1653c187b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff4cd3725b7293d413939f869201072df67963233381ab8c3f06ea8d35477fd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8431407714dba2a772cc32ae81b059fae632176946fa642c0254724cc959d37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "360c23e8bcf05fc484cd412c6972e492e425cc7f92be7f66f179907dc5acb346"
    sha256 cellar: :any_skip_relocation, sonoma:         "427b471f33eca0aaad516d3da41e281e32358076418e3783f34acbd855c962b9"
    sha256 cellar: :any_skip_relocation, ventura:        "d1a95fae7f45eca4621aa2103708afbb9d5a5c8d5984487382e23b0f297e3aa6"
    sha256 cellar: :any_skip_relocation, monterey:       "5111db38f82f48540a896aa414d3f2ac42275f9eec5eff7ef9fa52b0dbbddbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8328cb156aafb6a8b05e8c1d3a77e582f40f5823e325f8cf44e022ef4359ca8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http:localhost:#{port}")
    assert_match "HTTP1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end