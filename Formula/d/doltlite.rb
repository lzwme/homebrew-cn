class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://ghfast.top/https://github.com/dolthub/doltlite/releases/download/v0.50.15/doltlite-autoconf-0.50.15.tar.gz"
  sha256 "e91abce3c71f3f89a4b731d4afc4158ebdbe8e4787c0a7659d10800158d5438c"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dc57db3282f8291f38874219645030e1647f06b7fe293718b6fe07fa293f9e38"
    sha256 cellar: :any, arm64_tahoe:       "ad5092a9dade9a8be9862970cd9691788c3e9260ca70f649d7b985a37d162866"
    sha256 cellar: :any, arm64_sequoia:     "371d20ebeb498362ab2327de4545f280daa51a2be953bba5f79901a68936f8d7"
    sha256 cellar: :any, arm64_linux:       "eda778afdb9959b011496a9d2e971196d4edd5a6c54132aab09083db85b2fe07"
    sha256 cellar: :any, x86_64_linux:      "05a5f21cb8adb22efe9737d625ec64f6a0d8331b5efc8c55896d7f95a9ad7f27"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "doltlite", "doltlite-remotesrv", "doltlite-lib"
    # `make install` would also install `libsqlite3`, `sqlite3.h` and `sqlite3.1` from `sqlite`
    system "make", "install-shell-0", "install-doltlite-lib", "install-doltlite-headers"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doltlite :memory: 'SELECT dolt_version();'")

    (testpath/"hello.c").write <<~'C'
      #include <stdio.h>
      #include "doltlite.h"
      int main(void) {
        sqlite3 *db;
        if (sqlite3_open(":memory:", &db) != SQLITE_OK) return 1;
        sqlite3_close(db);
        printf("ok\n");
        return 0;
      }
    C

    system ENV.cc, "hello.c", "-I#{include}", "-L#{lib}", "-ldoltlite", "-o", "hello"
    assert_equal "ok", shell_output("./hello").chomp
  end
end