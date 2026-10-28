class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://ghfast.top/https://github.com/dolthub/doltlite/releases/download/v0.51.4/doltlite-autoconf-0.51.4.tar.gz"
  sha256 "473747661ddeac9203770b3872d6a70c0f13b8c088baec2e852dfecffbe2e0d4"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "879cc08d908db84751a9837b9bf7b9cd78f1269627ffb74da1b6b8b5a3786896"
    sha256 cellar: :any, arm64_tahoe:       "0562baea07165c985400387550f5e0f0a72258f33a7a1fa34485d9cb8eb9a1c7"
    sha256 cellar: :any, arm64_sequoia:     "559e4a0e8152299598f45111307e73ee4ca8ee180a2093d0b9c69560d71536c4"
    sha256 cellar: :any, arm64_linux:       "95da54a997f1f48be446321cb40d51fbab42f16b8698d61a072f9bf581e49d13"
    sha256 cellar: :any, x86_64_linux:      "ca5f5c60aae34332546906a67766f488a67050d451add87cd7279d8b75c0d59a"
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