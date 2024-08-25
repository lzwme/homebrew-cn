class Shpotify < Formula
  desc "Command-line interface for Spotify on a Mac"
  homepage "https:harishnarayanan.orgprojectsshpotify"
  url "https:github.comhnarayananshpotifyarchiverefstags2.1.tar.gz"
  sha256 "b41d8798687be250d0306ac0c5a79420fa46619c5954286711a5d63c86a6c071"
  license "MIT"
  head "https:github.comhnarayananshpotify.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a77b8a65c1e58b6bf20d640d688e62c01332f1663c7da3b37d7e0329280b4892"
  end

  def install
    bin.install "spotify"
  end

  test do
    system bin"spotify"
  end
end