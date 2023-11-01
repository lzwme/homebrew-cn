class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://ghproxy.com/https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "32343eda3b754db96428d6dbdb62b7f38088c630930dfe06f81640d45ae9edd6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ebab175368a466dd2f74549bc5bacaeb71b66cf3b39c1ad060dfdfe3237652d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c69498a399fb6c5c93b75272fc9895080259320969199f56050bbbf6ac7ffaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8263421a8bf51557bf5f5e6d7e5f8a820f656f1410caeeb52dcdd93ff8cbafd"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbe1a3d54443ea255eaebf99fe8ab4f0394e7484f09aed1c298282143efa250c"
    sha256 cellar: :any_skip_relocation, ventura:        "1bd24c21bbaf6878279d6f160e2c14ac71ae89d3760ae507ee64341df85ac388"
    sha256 cellar: :any_skip_relocation, monterey:       "2b88234368382699d2f15a1c6a9347ad6210325ffb9da2d5b24ff7769aa78c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0008e283f02e5f247d5cb58e04579f1f912c95fd4cf59115a149776cd827ab9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "404 Not Found", output
  ensure
    Process.kill("HUP", pid)
  end
end