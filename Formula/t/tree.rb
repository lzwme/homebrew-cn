class Tree < Formula
  desc "Display directories as trees (with optional colorHTML output)"
  homepage "https:oldmanprogrammer.netsource.php?dir=projectstree"
  url "https:github.comOld-Man-Programmertreearchiverefstags2.1.2.tar.gz"
  sha256 "d2a09b7c57473bf0451c37c2dbd5a72406ea2ee0810e97bd01a6a5459c0ea3fb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fdd34e46049ad22f376d1a38e9ab0a546c8d73c2069a8facc871c9457bf23d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51c5ed50ad02e86f0463a726c4b9d27a7e067a8be261c1b082dea1343ebd7f71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb61ff0606c967f1736780295957f8f9dadc544725db52383a6b7a837426558d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7c0c22a1fdda6cf20a6da8d4ad3ee08163070ada1c9ab2e36d9fb77e22675e2"
    sha256 cellar: :any_skip_relocation, ventura:        "e1c620de27c2cd3d2eff7b095f7c25be9cae42c7e2fab48fcd81f100bfef228b"
    sha256 cellar: :any_skip_relocation, monterey:       "61797963fba191a49aed039537e2435d59375ef7b8339296e15839e70aab2747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13ccbbcb094a96d079edf57b0bd873160240fa0f29035307e17ca761b6304bf7"
  end

  def install
    ENV.append "CFLAGS", "-fomit-frame-pointer"
    objs = "tree.o list.o hash.o color.o file.o filter.o info.o unix.o xml.o json.o html.o strverscmp.o"

    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "OBJS=#{objs}",
                   "install"
  end

  test do
    system "#{bin}tree", prefix
  end
end