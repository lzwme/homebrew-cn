class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.21.0.tar.gz"
  sha256 "05fc0b36d812a0bc6d2146bec03d929261dd08afa08f9de5ec38150dc9a68372"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56950b45eab1a1d6b56364aa754ed0c933b35f7448c7a454362cf2575bd7793c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56950b45eab1a1d6b56364aa754ed0c933b35f7448c7a454362cf2575bd7793c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56950b45eab1a1d6b56364aa754ed0c933b35f7448c7a454362cf2575bd7793c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f820ebcc8b7357628d36492792e69578c905ed42d622dfff556a9936a4d87da"
    sha256 cellar: :any_skip_relocation, ventura:        "3f820ebcc8b7357628d36492792e69578c905ed42d622dfff556a9936a4d87da"
    sha256 cellar: :any_skip_relocation, monterey:       "3f820ebcc8b7357628d36492792e69578c905ed42d622dfff556a9936a4d87da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3209d1bc625d2d90a7bfab9544d472e98e2a219c1e29547905422f008f9eb4b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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