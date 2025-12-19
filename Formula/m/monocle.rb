class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://ghfast.top/https://github.com/bgpkit/monocle/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "1adbd53056a193ac00b7d1b688c7adf9e37919376c978b41d7bb92ff25f4508a"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abf37d764e5d7994d4fd886a9f58bab154c7f0828b2a3444ec31999178c51106"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4925654319c3faa096a4438a0f939a40ed0a134aeb2e8f251485fe9c812f1d81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7b12858a6eda79681a8844f40e8ce9ecca72b5fe905e9b524b05f7c5706241e"
    sha256 cellar: :any_skip_relocation, sonoma:        "474a539abc372819c17a4f9bf836a87b0b5f19eefd1e5f9eea9145d8f126d9d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd0f8d9a1a86076f87ab950344f487734ded90c0bc12447e9152c1c3b6416e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cd0d3499addfde3ef1a8a8fedd2ae9f118f3ac334039c250812cd4c423c1c03"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/monocle time 1735322400 --simple")
    assert_match "2024-12-27T18:00:00+00:00", output
  end
end