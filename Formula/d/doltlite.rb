class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://ghfast.top/https://github.com/dolthub/doltlite/releases/download/v0.50.18/doltlite-autoconf-0.50.18.tar.gz"
  sha256 "ba609ea567ba7771547e9bbb1f4c5b2769b10ab9d032d4b136108d76bdf4a9c5"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0e9f917ade1d1a9d6380c765b2c67299afb7d070621a190e14ad9307ad1e9526"
    sha256 cellar: :any, arm64_tahoe:       "c66a5ab043db1daa0fd01b9f79c441c120f677f77af019ae527254b6910fc9e4"
    sha256 cellar: :any, arm64_sequoia:     "4f4bd270e84972b9b3526c2a2b65d6a07384e21bb5ead562bca08f8382171854"
    sha256 cellar: :any, arm64_linux:       "a4d812f135f128cae3b0dc53ff04e77cf083268f97e729c4b9f9f7413c380224"
    sha256 cellar: :any, x86_64_linux:      "1e8abb9d6c8fda9d6a0dfc4038c27bf2b3f29bb9908378c6970881d21148576d"
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