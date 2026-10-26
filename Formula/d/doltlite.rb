class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://ghfast.top/https://github.com/dolthub/doltlite/releases/download/v0.51.3/doltlite-autoconf-0.51.3.tar.gz"
  sha256 "80e63f3d0f4cc2bcea774e29f5541a752630ab1a465d9ae91bad9c52fd360dca"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5feeb87564b7c13ef29fd05b9444cf043d71002d3895043a009f626fd8298175"
    sha256 cellar: :any, arm64_tahoe:       "d76d3e8d1dd73fa506ac3333ca9e14d1f97af0abbecefac06536e6b073f0ac09"
    sha256 cellar: :any, arm64_sequoia:     "731224f0ae721c36d6438dbf585533df3e07ae1ee0adad35b837a14d2e0f878d"
    sha256 cellar: :any, arm64_linux:       "8c622579f441ad21ad20f6c1ecd7087b463653f98ffd12539a6ca6b5a895a303"
    sha256 cellar: :any, x86_64_linux:      "699d69742fc0b5c1220a4b23d39bd82873a98606ea9ea99e5c7558086d12b37b"
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