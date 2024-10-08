class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https:github.compostmodernruby-install"
  url "https:github.compostmodernruby-installreleasesdownloadv0.9.3ruby-install-0.9.3.tar.gz"
  sha256 "f1cc6c2fdba5591d7734c92201cca0dadb34038f8159ab89e0cf4e096ebb310a"
  license "MIT"
  head "https:github.compostmodernruby-install.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "f0f38dd79961d78a317bbdc6d0c72db9119812dae220526b011b653b40bf8ddc"
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