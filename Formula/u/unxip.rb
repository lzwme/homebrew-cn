class Unxip < Formula
  desc "Fast Xcode unarchiver"
  homepage "https:github.comsaagarjhaunxip"
  url "https:github.comsaagarjhaunxip.git",
      tag:      "v3.0",
      revision: "aeb6160a8a8e8b2bdc2e0b9f747a4b941046c624"
  license "LGPL-3.0-only"
  head "https:github.comsaagarjhaunxip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5df678380dc576645ab13265af663404c88cef771a7edf7ca0c72e7d7d2bf22d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7946cf4496d6f0718efe70b88c95932679c00a0f4398f0d6979cbad5c4cecd91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79f5dbbcea07409b9ce470c9bff60c82d4399db176b77bc450f2900022346377"
    sha256 cellar: :any_skip_relocation, sonoma:         "0662fe63df14c1571631b8f4e57381045e93d7f4269dc7e0b1c6d95bcaabc4d4"
    sha256 cellar: :any_skip_relocation, ventura:        "0fdd0cc7f70a1ebc9181687ebbdff2401a7f7a8e3e11aa50e7d0c8f58748097d"
    sha256 cellar: :any_skip_relocation, monterey:       "039ceba020c663073c09912b6c25230a4735cff3bf775074e5d3e4bba5591c1d"
  end

  depends_on xcode: :build
  depends_on :macos
  depends_on macos: :monterey
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".buildreleaseunxip"
  end

  test do
    assert_equal "unxip #{version}", shell_output("#{bin}unxip --version").strip

    # Create a sample xar archive just to satisfy a .xip header, then test
    # the failure case of expanding to a non-existent directory
    touch "foo.txt"
    system "xar", "-c", "-f", "foo.xip", "foo.txt"
    assert_match %r{^Failed to access output directory at notarealdir.*$},
      shell_output("2>&1 #{bin}unxip foo.xip notarealdir", 1)
  end
end