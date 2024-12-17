class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https:github.compostmodernruby-install"
  url "https:github.compostmodernruby-installreleasesdownloadv0.9.4ruby-install-0.9.4.tar.gz"
  sha256 "c932e5a61e5cf11056ba6224fd75f75f2a71a991d4fc216d670ba96d7cc5c6a0"
  license "MIT"
  head "https:github.compostmodernruby-install.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f469f77ab8e75bfd324cafaa522d5245a68c345d343f8996a8a16ba497981712"
  end

  depends_on "xz"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # Ensure uniform bottles across prefixes
    inreplace man1"ruby-install.1", "usrlocal", "$HOMEBREW_PREFIX"
    inreplace [
      pkgshare"ruby-install.sh",
      pkgshare"trufflerubyfunctions.sh",
      pkgshare"truffleruby-graalvmfunctions.sh",
    ], "usrlocal", HOMEBREW_PREFIX
  end

  test do
    system bin"ruby-install"
  end
end