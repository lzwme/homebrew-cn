class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://ghfast.top/https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.31.1.tar.gz"
  sha256 "1890ca1c2f0aff60097c69efb65b51249fee3e19ff0811affc06da9abf7144bd"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cd82b68ab082ad94b3ade12f09a0c788262ec37495679e3ec6710ebf898a3fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d83b743a766c192980b361d3879d623fccc0cc38839363f8c9741a22bf2142f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bf11904614beccef4cbaa235db25ccfbafd41e10c7f19f9a48299b27b5b9977"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1a829b99fbffd13591006fbeb0013c4cc2a3de01b8739f793df734de280de99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4f0a00cb3762cacbd21ecef76dcff86807d4766885e0b3a5cca2e0c9586e37a"
    sha256 cellar: :any,                 x86_64_linux:  "e92f3b3c42697348b26c6e6ff95514d167063fbe007cec808bda492f922f7835"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    pid = spawn bin/"pmtiles", "serve", ".", "--port", port.to_s
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end