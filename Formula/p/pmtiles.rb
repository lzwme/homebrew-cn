class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.22.3.tar.gz"
  sha256 "d57fdbcc3117863c30076df68371c08abecfd10de9b336c4eb166723e6d324e5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bf1210d16eb26a5aaa4903e3baa4a537eb73ac26064bd17db1a342dda9328d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bf1210d16eb26a5aaa4903e3baa4a537eb73ac26064bd17db1a342dda9328d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bf1210d16eb26a5aaa4903e3baa4a537eb73ac26064bd17db1a342dda9328d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f686891b28f526000501c767b835ba5d2e18aa3bd96626c6b93e42261ccce81"
    sha256 cellar: :any_skip_relocation, ventura:       "9f686891b28f526000501c767b835ba5d2e18aa3bd96626c6b93e42261ccce81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "848987e43218d909c2522241d9960ec6514fd48afba7b90af8b4204075e3a726"
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