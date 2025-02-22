class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.25.2.tar.gz"
  sha256 "d8996597dc11ef05dad42ec67802eb77427c08f1d9cc9cb46df17edb064cb9cf"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8316d156f5d4eed1fd322e2767c69dae1c9a336af931e97adf31cf757f895f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8316d156f5d4eed1fd322e2767c69dae1c9a336af931e97adf31cf757f895f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8316d156f5d4eed1fd322e2767c69dae1c9a336af931e97adf31cf757f895f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaf2233aa42e79181ce1005111571f9f1e97cda7608b1662d5808db3b30a6a15"
    sha256 cellar: :any_skip_relocation, ventura:       "eaf2233aa42e79181ce1005111571f9f1e97cda7608b1662d5808db3b30a6a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4484e414d5986ecd5b4c8c2b9b43d3a1e7c942e03d63db950dac9d9b0be80369"
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