class BerkeleyDb < Formula
  desc "High performance keyvalue database"
  homepage "https:www.oracle.comdatabasetechnologiesrelatedberkeleydb.html"
  url "https:download.oracle.comberkeley-dbdb-18.1.40.tar.gz"
  mirror "https:fossies.orglinuxmiscdb-18.1.40.tar.gz"
  sha256 "0cecb2ef0c67b166de93732769abdeba0555086d51de1090df325e18ee8da9c8"
  license "AGPL-3.0-only"
  revision 2

  livecheck do
    url "https:www.oracle.comdatabasetechnologiesrelatedberkeleydb-downloads.html"
    regex(Berkeley\s*DB[^(]*?\(\s*v?(\d+(?:\.\d+)+)\s*\)i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8a6da9be201214ca17efa824a335060a6f1ff4d72cc579a5878ee06ac2d9b61"
    sha256 cellar: :any,                 arm64_ventura:  "67fed25d26cb987106b346ee4088959b71306db6a016cb6f58cca9da9350c36d"
    sha256 cellar: :any,                 arm64_monterey: "e5416a45caf56653c4691f5d939df58d9da2254807efd6ab5425cfa63a472ac9"
    sha256 cellar: :any,                 arm64_big_sur:  "a68f9cf2daa3a03ea5c9c9e072955d2dec43aff19859ef2c40888b7b85ea379f"
    sha256 cellar: :any,                 sonoma:         "01746c62817e50160208bd9acb690eec9352e89b5a3b8bda6bea3952b9bc4352"
    sha256 cellar: :any,                 ventura:        "a6b04772ee3978ec98f1e3e79fec872c9dc5476b49b7d70218e5c850af6ecf79"
    sha256 cellar: :any,                 monterey:       "6db05f803f05820f25cdd5936a8d23615ef886f0a409946d40d966cf5f35f023"
    sha256 cellar: :any,                 big_sur:        "5f4917a225a5986f682c85dbcfb6503024738d6eadb637161210ae621c26f457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba948d2977fbfcc865086fab6d6567b4f3972fcc46e327817fb7600f64d4312"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    directory "dist"
  end

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize

    # --enable-compat185 is necessary because our build shadows
    # the system berkeley db 1.x
    args = %W[
      --disable-debug
      --disable-static
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
      --enable-compat185
      --enable-sql
      --enable-sql_codegen
      --enable-dbm
      --enable-stl
    ]

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd "build_unix" do
      system "..distconfigure", *args
      system "make", "install", "DOCLIST=license"

      # delete docs dir because it is huge
      rm_rf prefix"docs"
    end
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <assert.h>
      #include <string.h>
      #include <db_cxx.h>
      int main() {
        Db db(NULL, 0);
        assert(db.open(NULL, "test.db", NULL, DB_BTREE, DB_CREATE, 0) == 0);

        const char *project = "Homebrew";
        const char *stored_description = "The missing package manager for macOS";
        Dbt key(const_cast<char *>(project), strlen(project) + 1);
        Dbt stored_data(const_cast<char *>(stored_description), strlen(stored_description) + 1);
        assert(db.put(NULL, &key, &stored_data, DB_NOOVERWRITE) == 0);

        Dbt returned_data;
        assert(db.get(NULL, &key, &returned_data, 0) == 0);
        assert(strcmp(stored_description, (const char *)(returned_data.get_data())) == 0);

        assert(db.close(0) == 0);
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -ldb_cxx
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system ".test"
    assert_predicate testpath"test.db", :exist?
  end
end