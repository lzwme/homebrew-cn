class Wush < Formula
  desc "Transfer files between computers via WireGuard"
  homepage "https:github.comcoderwush"
  url "https:github.comcoderwusharchiverefstagsv0.1.2.tar.gz"
  sha256 "8e1ffd24b51775ac68116b381cf4523a54d4e7742e440b7d279418faa52904eb"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "70744ec0f6419b15973882fd4620c585a83d0688ecf2532ca206834452af27f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55be2f80aef9e2edd1dc8ccd5d4446564ef4d867694d4688c12871f0bf1b552e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bf2232ebe8555126b5c7d42536dcb7cac0ef1256f8e3f9e6e55ad051d486421"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45dadb5bef4cbbe4963cf44f82d3d70c19c5f3f19e14409a7f8f25f3f5463df8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ad68dddde27cf173f7bc31c2851d31bda5b160149dde5d7a141767b48ebfa75"
    sha256 cellar: :any_skip_relocation, ventura:        "1effeb2d4cfa71f7b35d0f031141872f29fd0a9b0ecf462208624bfc17a809d9"
    sha256 cellar: :any_skip_relocation, monterey:       "dadfd9815b1eacd11d77969c3ee911f61b4bff2f370684e568462e5e88fd3ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd1b0ca47659326e64f161e44fdfe8f424c0359538672e50126e12b5fdd333d3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdwush"
  end

  test do
    read, write = IO.pipe

    pid = fork do
      exec bin"wush", "serve", out: write
    end

    output = read.gets
    assert_includes output, "Picked DERP region"
    output = read.gets
    assert_includes output, "Your auth key is:"
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end