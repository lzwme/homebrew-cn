class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://ghfast.top/https://github.com/dolthub/doltlite/releases/download/v0.51.0/doltlite-autoconf-0.51.0.tar.gz"
  sha256 "711090b301c4e0a497e0ae115adbc4c657150fe1094e760d9c039f8c419c4048"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a9cf5713c8449dba6fe861d956348e53899d0ea683e94c6d6ee40394de71b507"
    sha256 cellar: :any, arm64_tahoe:       "4724874e28b1138f98afa2108b4cc466e5c5316fb8492958f14e79f8e497e6db"
    sha256 cellar: :any, arm64_sequoia:     "c5702067661a3aeb58fedc38664efe507b161cfa0095dd6d6d75002d52223e41"
    sha256 cellar: :any, arm64_linux:       "0f287d668c7ed277aecf9b14005d6531fdf9b4e3ecbc271e35697056544cbda0"
    sha256 cellar: :any, x86_64_linux:      "6578553cc877ffaf41a148535f94b877cced8d02c0fe028e40abaa0552bd7640"
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