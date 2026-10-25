class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://ghfast.top/https://github.com/dolthub/doltlite/releases/download/v0.51.2/doltlite-autoconf-0.51.2.tar.gz"
  sha256 "d6bb40c5f2299c79f9872fc9434dbead95078941cc802ff28c5a55d088467393"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "31c7dab0f38c9a002856aef7c54d85debd135bb6dd4c78028a963d4b4ce96507"
    sha256 cellar: :any, arm64_tahoe:       "1d8a0c3adb959785ac76f26bb6433c9605f9b267238d365be1a5cbfbd62c2961"
    sha256 cellar: :any, arm64_sequoia:     "9ed2548d7882630aec1f2c71d179a4528b019868c1319cfd6b64f826fedda77f"
    sha256 cellar: :any, arm64_linux:       "7bd9fd6c6fe2cc622d6a7ccf6410fc746f859c381fd85c93c8e3e8bb9a7fa548"
    sha256 cellar: :any, x86_64_linux:      "9d354ffb6e32ae4407f43c4b2e57faad2d4433f93acb89e0a0ec7c8eea9f501e"
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