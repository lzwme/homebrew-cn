class Fileicon < Formula
  desc "macOS CLI for managing custom icons for files and folders"
  homepage "https:github.commklement0fileicon"
  url "https:github.commklement0fileiconarchiverefstagsv0.3.4.tar.gz"
  sha256 "c5673cafa9479eb1c3ec312e6673b912bc1630b361732da137428859e037dd91"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "aa252af1391dd8a1b287c031744dbf034fa98dd1f1961c4200e38813b1fee9dd"
  end

  depends_on :macos

  def install
    bin.install "binfileicon"
    man1.install "manfileicon.1"
  end

  test do
    icon = test_fixtures "test.png"
    system bin"fileicon", "set", testpath, icon
    assert_path_exists testpath"Icon\r"
    stdout = shell_output "#{bin}fileicon test #{testpath}"
    assert_includes stdout, "HAS custom icon: folder '#{testpath}'"
  end
end