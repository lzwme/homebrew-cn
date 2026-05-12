class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "22aac1b88313504a78af6c47a4c64aea081df5e0ab7a7f12d603db6ec770effa"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "945d16da875cb96d00d5171d6012275626deeacd828ccbd373f3cdfdad948da2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "945d16da875cb96d00d5171d6012275626deeacd828ccbd373f3cdfdad948da2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "945d16da875cb96d00d5171d6012275626deeacd828ccbd373f3cdfdad948da2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f828af65e10080b1c4f93684980eec86de0113bd538cf05cfb4de9334d1ea652"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c50b6019c23bc679ce098ebeb34179405a6c9d1b7f66a2e80f26884c7b69e2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27b80a20cfd4fc367df1d60673b77286d14096638fc74e041320302d1cab83ab"
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