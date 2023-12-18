class Makeself < Formula
  desc "Generates a self-extracting compressed tar archive"
  homepage "https:makeself.io"
  url "https:github.commegastepmakeselfarchiverefstagsrelease-2.5.0.tar.gz"
  sha256 "705d0376db9109a8ef1d4f3876c9997ee6bed454a23619e1dbc03d25033e46ea"
  license "GPL-2.0-or-later"
  head "https:github.commegastepmakeself.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b3a72be9c86fc9bab224745ea276baf2ab23742c3e57cabe4fa22e76b1d6d43c"
  end

  def install
    # Replace `usrlocal` references to make bottles uniform
    inreplace ["makeself-header.sh", "makeself.sh"], "usrlocal", HOMEBREW_PREFIX
    libexec.install "makeself-header.sh"
    # install makeself-header.sh to libexec so change its location in makeself.sh
    inreplace "makeself.sh", '`dirname "$0"`', libexec
    bin.install "makeself.sh" => "makeself"
    man1.install "makeself.1"
  end

  test do
    source = testpath"source"
    source.mkdir
    (source"foo").write "bar"
    (source"script.sh").write <<~EOS
      #!binsh
      echo 'Hello Homebrew!'
    EOS
    chmod 0755, source"script.sh"
    system bin"makeself", source, "testfile.run", "'A test file'", ".script.sh"
    assert_match "Hello Homebrew!", shell_output(".testfile.run --target output")
    assert_equal (source"foo").read, (testpath"outputfoo").read
  end
end