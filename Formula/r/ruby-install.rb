class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https:github.compostmodernruby-install"
  url "https:github.compostmodernruby-installreleasesdownloadv0.10.1ruby-install-0.10.1.tar.gz"
  sha256 "7f563af2bae257c006a5dba0b1976e0885d3814332cc4391eeaa88d702753289"
  license "MIT"
  head "https:github.compostmodernruby-install.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "830bb609eb27783b5bb8de44341d16bffd24f18fdc6f453d6f21ea136ef7b4e3"
  end

  depends_on "xz"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # Ensure uniform bottles across prefixes
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