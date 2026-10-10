class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://ghfast.top/https://github.com/dolthub/doltlite/releases/download/v0.50.17/doltlite-autoconf-0.50.17.tar.gz"
  sha256 "c0f44e749c9e2efb2c4f7b02e76e675f0bf3c85efddebeb6844b0f004938ab87"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "75142360a2f6cf56728cb677494f9cd8b6348bc35f1578cb2815348dc6f75ff4"
    sha256 cellar: :any, arm64_tahoe:       "d02bd7563fba931139b47eceeeb68d05583bb03430a2ee046d1ee0b4bd25d7dc"
    sha256 cellar: :any, arm64_sequoia:     "0d7e8bd651490a9e4193023409f6dd2324da609fa3f4c7080ed8c42486fbb66d"
    sha256 cellar: :any, arm64_linux:       "1e042d2cd53a2403049ff14512505f4c6517deba1731b90cf9237c6597a36f48"
    sha256 cellar: :any, x86_64_linux:      "0666ce35db6db64df6241eb438b7ea43fa84e8898f5d27edd818b8ea660923d4"
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