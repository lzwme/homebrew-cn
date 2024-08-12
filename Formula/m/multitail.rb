class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https:vanheusden.commultitail"
  url "https:github.comfolkertvanheusdenmultitailarchiverefstags7.1.4.tar.gz"
  sha256 "96b781a9c22f3518fc25c4f3ce3833ec5069158b2a743a30f7586cd063824704"
  license "MIT"
  head "https:github.comfolkertvanheusdenmultitail.git", head: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "56469c7b2b950499b3b214252f448d7c9291ba830cc942077a5fa08fe64a5109"
    sha256 cellar: :any,                 arm64_ventura:  "64d9dc879b87a414f1ab4bcb1f5a5666eab23414b93162ff12f63d397ac772a8"
    sha256 cellar: :any,                 arm64_monterey: "ff18c529e31bbd7798acf2347bdae5a80c2d90e533f790b419f714ec276578b6"
    sha256 cellar: :any,                 sonoma:         "f249a23652a90f76bb48a944ed7b14baad2c7ce1b4fa8475f8e23abc121d37d0"
    sha256 cellar: :any,                 ventura:        "44c0b25849a46a11ae8bccdf89162a29322577b3124ecf6fb852b87f9ec78afb"
    sha256 cellar: :any,                 monterey:       "590e896fb99591eb654991ec625300357ac268f14737732888ab7f2b53406efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2535a0a2ca60556988407902550b9fbbf89831843fe58916e774bf6e469f2428"
  end

  depends_on "pkg-config" => :build
  depends_on "ncurses"

  def install
    odie "remove version patch" if build.stable? && version > "7.1.4"
    inreplace "version", "7.1.3", version.to_s

    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install Utils::Gzip.compress("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}multitail -h 2>&1", 1)
  end
end