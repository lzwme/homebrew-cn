class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://ghproxy.com/https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "2ca4875df5f2500589cc6287f63a8d305493014a647f09d1ac7348ccf27a50f6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "391af302125b8cd70aed77c044920dbf7aa8263581c16654b024b1874820b11c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d5232dfe39026e92c99ca7f174a42388e6e732cbab2acb5f0361251fe6fa8cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a7afb4886c212f7b156632c38e1f5786fcf0f310d62094820319d522fdff0d3"
    sha256 cellar: :any_skip_relocation, ventura:        "b85d5d4c6d3435735d752c5c59b0c84976931616d5ceb31f5c9e72524c8e8433"
    sha256 cellar: :any_skip_relocation, monterey:       "e802d643c823b17cfd4c07451a87dd6fd19a5c865ea6efed98bde41c28b7edaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcfd3126f2ac807742761ca42b9b606d5417a92b5e23f9992c116e5912d404c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dee941901796fc18511d694b81d56852e4f9f1c65899669c53af19973cde7df"
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