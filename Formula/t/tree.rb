class Tree < Formula
  desc "Display directories as trees (with optional colorHTML output)"
  homepage "https:oldmanprogrammer.netsource.php?dir=projectstree"
  url "https:github.comOld-Man-Programmertreearchiverefstags2.2.0.tar.gz"
  sha256 "c4964b503d609e7146edd75566b978b1853e2cebee7c0342be230cbd84da326c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da86b349a512a06a0646ac0e729f6a422dbe09ddd0b6045368e5f91d13338181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cdb04082e8fbed9dbafcc8e7a4e7d9afc2af0ce36725e0c31bf7fde830405e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "891da675b57ff1a34b83f06b3cc491cdbbd689ba0506589e7c12a368b6e30d0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "42a58ba4de938e595943efcd568d7272c63eb7bbdb402d9a94b6e62a53dbc971"
    sha256 cellar: :any_skip_relocation, ventura:       "cf0029ab3cbe9b515a7f2ade2a29ca5ef604802de40f80d86447530ae61387d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb859ce5d27196a3765c1c2265641e30de7d4d295511f5e6e13f8c1b70feb708"
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
    system bin"tree", prefix
  end
end