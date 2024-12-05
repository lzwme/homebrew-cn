class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.22.2.tar.gz"
  sha256 "1aaa75c441e53c5a0bd9917ee996e0eb471032c8a217e2c276f6b7a65f987eb9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6572761212178f45b1d6d51c93d1b0a02b4c8044c8d494bfe1f4e2cc114aa2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6572761212178f45b1d6d51c93d1b0a02b4c8044c8d494bfe1f4e2cc114aa2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6572761212178f45b1d6d51c93d1b0a02b4c8044c8d494bfe1f4e2cc114aa2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "80fc31f9fff0f06ac150afa770f37673c050f9fe0d414dcdf4fbb0159bf0b1e6"
    sha256 cellar: :any_skip_relocation, ventura:       "80fc31f9fff0f06ac150afa770f37673c050f9fe0d414dcdf4fbb0159bf0b1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "210d675c25b450df7cb8dbc0b2d2021e997d7647a9b608575d6e597b75d471a4"
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