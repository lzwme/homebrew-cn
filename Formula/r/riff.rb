class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://ghfast.top/https://github.com/walles/riff/archive/refs/tags/3.5.0.tar.gz"
  sha256 "6fa7491053abd5fdd1fd247596ea3bdde18309a52470b1c9a9eb6ed84ed8e1ad"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26c7abf12912316474e09bce0c3b0aa38ff0a342121b8c80f8e8fbc9395fe24d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4013a2fb86700f134a91db056eb847f9f23b85bde9ebe240a88ba09b5930b9d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4e8e09a936a0e9f4e56875970f78d8a8d6d3657307fc8fbcda8701b3d80239d"
    sha256 cellar: :any_skip_relocation, sonoma:        "83c5867db82d33f8e68f38ea1863a34c1a2c024c6165b70295c10e24507771b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a72d6d3d4af53d21bdccd203e982d97d90bc14a47c7e5d17a94dfd6c08923f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db0e8373568e17f20d517f41c9a109148a91aa4cf470bb29ee3cc5adbcb83d38"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end