class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://ghproxy.com/https://github.com/xyproto/algernon/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "023779d8516da9ce5f3b1af9d0173652f2f1fab0d036b636e4185c3b8d5242c5"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3948e02695ff42de507067e3daee9a80f5b23f044ee5fd9b41e81ff0517b71e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a892170a394119622284bb11619307b81cd7f2d14ab9db6af86f72ad190297d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b4d024ae802b8bc6fe208a7c24bb8b6ccbe13224bda822594515fbbe9b2ed96"
    sha256 cellar: :any_skip_relocation, ventura:        "d672a6e8289bde0d4bbe85473910be0dd68a3e29f4936d27557853b6937bc579"
    sha256 cellar: :any_skip_relocation, monterey:       "5e0fd44f1d67719b3e8ac9335d27a10ee77ea1b27fa45368a929c7eb8ef32149"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b8fdfa3dcb0d42e6f6169e0b12f0dfdcc2e1f7cc9f907e26373b02d0591839c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d54da360b720e08a23181afb845b62bcea6d0a6624a0a1c7546a931b4d5841da"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/xyproto/algernon/commit/00f29f8bcd0da772041a96fa9b57f7e1e21a6654
  # Remove on next release.
  depends_on "go@1.19" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end