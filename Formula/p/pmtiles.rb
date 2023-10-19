class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://ghproxy.com/https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "cd7d0dc095308e9e19a8e4c4e5d195ba6ff89119f779afccc2c214bbe7057fb3"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7ab515614f358cdadee16b878174aaca486856520132d9bb0126e42fc834ae8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67505107979ed911a7b0a862fb1fc41335489d7194c81e7172b72ec36cff7bba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "275e3ac48dc32eebb98fc096a087ae0c189e2284bcdf3814caf88c69511157f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2dc8456841f4f6371700f980de077566733532c3f7d00b2bef7d2551a76fc998"
    sha256 cellar: :any_skip_relocation, ventura:        "b071db1be6b4ec9270d429fbaa4da59ff3248848a73e00609d8bf2ca32be5748"
    sha256 cellar: :any_skip_relocation, monterey:       "838bef7195fc13c69005ab5628aa2396003d9e78e6fda04684326d8518247a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ebe81aa69fde283890d41431c0274f48221dae26ae3eeb981801f623f72a4bf"
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