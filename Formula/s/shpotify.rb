class Shpotify < Formula
  desc "Command-line interface for Spotify on a Mac"
  homepage "https://harishnarayanan.org/projects/shpotify/"
  url "https://ghproxy.com/https://github.com/hnarayanan/shpotify/archive/refs/tags/2.1.tar.gz"
  sha256 "b41d8798687be250d0306ac0c5a79420fa46619c5954286711a5d63c86a6c071"
  license "MIT"
  head "https://github.com/hnarayanan/shpotify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "55b64a8511959f5d3e7b2d5743f5d8839263767fe22a59534d3d019e2bc8738b"
    sha256 cellar: :any_skip_relocation, sonoma:       "55b64a8511959f5d3e7b2d5743f5d8839263767fe22a59534d3d019e2bc8738b"
    sha256 cellar: :any_skip_relocation, all:          "e15fab27ffc271dd4fbb5317540b1628e30b79cb5cdaed0f51eb956873876565"
  end

  def install
    bin.install "spotify"
  end

  test do
    system "#{bin}/spotify"
  end
end