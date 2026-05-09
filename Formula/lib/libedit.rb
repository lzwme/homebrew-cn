class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20260508-3.1.tar.gz"
  version "20260508-3.1"
  sha256 "91f42d6571dd8d92faedd1341134ce5abca0c5d0b4b352814186d33f2b11272e"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a3b62f6173c34cf7fae335012f921561b1edc505cd84eaa8930a6222bbc767d"
    sha256 cellar: :any,                 arm64_sequoia: "193ac4813b303c99db66593a5ecc2a4d00d3bfb2c71515e6d8a3b5e8f5b2ffcd"
    sha256 cellar: :any,                 arm64_sonoma:  "05f1e245f406feec6a9d07586bdd67af8f49a7c33d341d3e49b5c24d87ea1645"
    sha256 cellar: :any,                 sonoma:        "5f1f51c13054908d2375fc52c861bf80bf04190012e5b4686d3fbb3d6bd804bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8b029f464a75a11fb40395638efa8091f1cf65c8b34c1987f36aa4cd0300ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8493197581ff513e9be68c354f8d498b0ac6a79a9430abed7d6b69ada352446"
  end

  keg_only :provided_by_macos

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"

    # Create readline compatibility symlinks for use by license incompatible
    # software. We put these in libexec to avoid conflict with readline.
    # Similar to https://packages.debian.org/sid/libeditreadline-dev
    %w[history readline].each do |libname|
      (libexec/"include/readline").install_symlink include/"editline/readline.h" => "#{libname}.h"
      (libexec/"lib").install_symlink lib/shared_library("libedit") => shared_library("lib#{libname}")
      (libexec/"lib").install_symlink lib/"libedit.a" => "lib#{libname}.a"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end