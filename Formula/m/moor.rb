class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "da5e3209d78ad811491ae49c50140366fcb56ddc9fc0d3a65199efe968337d33"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d2617410274721a8f9003189188b11a6d1c4cb6a43231ef362464da30e6358a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d2617410274721a8f9003189188b11a6d1c4cb6a43231ef362464da30e6358a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d2617410274721a8f9003189188b11a6d1c4cb6a43231ef362464da30e6358a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6193f8ccc4999af6d9f06120f4bf6bd47391b0b5520fd148b36ebb47b0459cca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1012e18f51f757be652b825cdbdc37fa1643793957fcd276c1355e72acc46ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53e258a35c711339db2176d277c0ee1cdfd05c34161610e9a722fd63e36c62ee"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end