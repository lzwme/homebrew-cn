class Cgit < Formula
  desc "Hyperfast web frontend for Git repositories written in C"
  homepage "https:git.zx2c4.comcgit"
  url "https:git.zx2c4.comcgitsnapshotcgit-1.2.3.tar.xz"
  sha256 "5a5f12d2f66bd3629c8bc103ec8ec2301b292e97155d30a9a61884ea414a6da4"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https:git.zx2c4.comcgitrefstags"
    regex(href=.*?cgit[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia:  "451caf4e50e0fb28a7bcdc287bfef5c75770e81b82fd21157868131ee0a5bff3"
    sha256 arm64_sonoma:   "6405d9f29445c303d1a5c89d9f15a512940414aba9194a5e421eca6d5ef60e8d"
    sha256 arm64_ventura:  "8435a3e97f7d97b0a81af4d65387edba8da214f8d348cac06a0200dfd861ca83"
    sha256 arm64_monterey: "3e517a8b04d86f340eeba6bdd52d3a187db3e604137b5d0cc3f5a0a5547d65b3"
    sha256 arm64_big_sur:  "27b3ceaddc63451dd3b57c153dc9f4810326884929e4839ef430d43d2b39d197"
    sha256 sonoma:         "498e122cc325bc2df8e2950640523ee0305ddd99eaf06ba85ada870727157740"
    sha256 ventura:        "2f2b6641da929056912b8999d35801a707380714abc20dc56d5c38445f017066"
    sha256 monterey:       "3e955c47ed5c722d9124b1a2efc90b7ac46e5cc89c0bf8772b2dd9061bb54a56"
    sha256 big_sur:        "9e0084dfe5c75d91bf5b6494f6e15534cff838ac52a866e4c8667062dcdd2eb2"
    sha256 catalina:       "787b27262a5998a5dba017d0f75bfa3dadef68b7e3730d87719b1ab48536814d"
    sha256 arm64_linux:    "24b850675c1e7ea4ac15cf76ba4666649e9d6ae82e43e84136185247e50929a7"
    sha256 x86_64_linux:   "472e74b2dec4db2de6714623b092f441e17d9806e5316c3597895329fde2abc3"
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "openssl@3" => :build # Uses CommonCrypto on macOS
  end

  # git version is mandated by cgit: see GIT_VER variable in Makefile
  # https:git.zx2c4.comcgittreeMakefile?h=v1.2#n17
  resource "git" do
    url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.25.1.tar.gz"
    sha256 "4999ae0ee6cc7dfb280d7051e39a82a5630b00c1d8cd54890f07b4b7193d25aa"
  end

  # cgit 1.2.2+ needs memrchr, for which macOS provides no implementation
  # https:lists.zx2c4.compipermailcgit2020-August004510.html
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches5decb544ec505d0868ef79f03707fafb0e85e47ccgitmemrchr-impl.patch"
    sha256 "3ab5044db3001b411b58309d70f00b0dee54df991ebc66da9406711ed4007f0f"
  end

  def install
    resource("git").stage(buildpath"git")
    system "make", "prefix=#{prefix}",
                   "CGIT_SCRIPT_PATH=#{pkgshare}",
                   "CGIT_DATA_PATH=#{var}wwwhtdocscgit",
                   "CGIT_CONFIG=#{etc}cgitrc",
                   "CACHE_ROOT=#{var}cachecgit",
                   "install"
  end

  test do
    (testpath"cgitrc").write <<~EOS
      repo.url=test
      repo.path=#{testpath}
      repo.desc=the master foo repository
      repo.owner=fooman@example.com
    EOS

    ENV["CGIT_CONFIG"] = testpath"cgitrc"
    # no "Status" line means 200
    refute_match(Status: .+, shell_output("#{pkgshare}cgit.cgi"))
  end
end