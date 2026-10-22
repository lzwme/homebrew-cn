class Ejdb < Formula
  desc "Embeddable JSON Database engine C11 library"
  homepage "https://ejdb.org"
  url "https://github.com/Softmotions/ejdb.git",
      tag:      "v2.93",
      revision: "c9394e229af2c6db747c83caae1cca74ed77e670"
  license "MIT"
  head "https://github.com/Softmotions/ejdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "37ef9f14a48a470ca4e9037115bd6e9fb4f1a9918aa5fbc07aaa499e02da94c3"
    sha256 cellar: :any, arm64_tahoe:       "56662dad6e3d731a18f5443365a535dc00551438ca7b198919d1fcd3bb8b1a27"
    sha256 cellar: :any, arm64_sequoia:     "ed7b32afae6ff47f8cd908cdc979f7be041d43b7fd7a8976e58d62b2ab98e9c7"
    sha256 cellar: :any, arm64_linux:       "d37f2c94d134e7d6f2036bf81a037248dc9d1dde5876fe5c0601862f49c3d044"
    sha256 cellar: :any, x86_64_linux:      "93d2af92cd98d8f567a0e63a35021a5cf4b9937c452527675deae40ae708629c"
  end

  depends_on "pkgconf" => :build

  fails_with :gcc do
    version "7"
    cause <<~EOS
      build/src/extern_iwnet/src/iwnet.c: error: initializer element is not constant
      Fixed in GCC 8.1, see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=69960
    EOS
  end

  resource "iwnet" do
    url "https://ghfast.top/https://github.com/Softmotions/iwnet/archive/refs/tags/v1.4.0.tar.gz"
    sha256 "4ea347171f5a39d8755d3f240c84a9e340a9839d1fd36110f10b03e5ce948a36"
  end

  resource "iowow" do
    url "https://ghfast.top/https://github.com/Softmotions/iowow/archive/refs/tags/v1.7.0.tar.gz"
    sha256 "3e2c12bad094e3e3f9c21f06123f1f7f6d322535dfbbd4d5b9f9d742ce783099"
  end

  deny_network_access! :test

  def install
    resources.each do |r|
      r.stage buildpath/r.name
    end

    # Keep dependency libraries in Homebrew's lib directory on Linux too.
    inreplace ["Autark", "iwnet/iowow.autark"], "--prefix", "--libdir=lib --prefix"

    # Use the staged resource instead of downloading it.
    inreplace "iwnet/iowow.autark",
              %r{https://github\.com/Softmotions/iowow/archive/\S+\.zip},
              "dir://#{buildpath}/iowow"

    # Bundled peg's `make install` can copy its man page before creating the directory
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "./build.sh", "--prefix=#{prefix}", "--libdir=lib", "--jobs=#{jobs}",
                         "-DIWNET_URL=dir://#{buildpath}/iwnet", "-DEJDB_BUILD_SHARED_LIBS=1"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <ejdb2/ejdb2.h>

      #define RCHECK(rc_)          \\
        if (rc_) {                 \\
          iwlog_ecode_error3(rc_); \\
          return 1;                \\
        }

      static iwrc documents_visitor(EJDB_EXEC *ctx, const EJDB_DOC doc, int64_t *step) {
        // Print document to stderr
        return jbl_as_json(doc->raw, jbl_fstream_json_printer, stderr, JBL_PRINT_PRETTY);
      }

      int main() {

        EJDB_OPTS opts = {
          .kv = {
            .path = "testdb.db",
            .oflags = IWKV_TRUNC
          }
        };
        EJDB db;     // EJDB2 storage handle
        int64_t id;  // Document id placeholder
        JQL q = 0;   // Query instance
        JBL jbl = 0; // Json document

        iwrc rc = ejdb_init();
        RCHECK(rc);

        rc = ejdb_open(&opts, &db);
        RCHECK(rc);

        // First record
        rc = jbl_from_json(&jbl, "{\\"name\\":\\"Bianca\\", \\"age\\":4}");
        RCGO(rc, finish);
        rc = ejdb_put_new(db, "parrots", jbl, &id);
        RCGO(rc, finish);
        jbl_destroy(&jbl);

        // Second record
        rc = jbl_from_json(&jbl, "{\\"name\\":\\"Darko\\", \\"age\\":8}");
        RCGO(rc, finish);
        rc = ejdb_put_new(db, "parrots", jbl, &id);
        RCGO(rc, finish);
        jbl_destroy(&jbl);

        // Now execute a query
        rc =  jql_create(&q, "parrots", "/[age > :age]");
        RCGO(rc, finish);

        EJDB_EXEC ux = {
          .db = db,
          .q = q,
          .visitor = documents_visitor
        };

        // Set query placeholder value.
        // Actual query will be /[age > 3]
        rc = jql_set_i64(q, "age", 0, 3);
        RCGO(rc, finish);

        // Now execute the query
        rc = ejdb_exec(&ux);

      finish:
        if (q) jql_destroy(&q);
        if (jbl) jbl_destroy(&jbl);
        ejdb_close(&db);
        RCHECK(rc);
        return 0;
      }
    C

    system ENV.cc, "-I#{include}/ejdb2", "test.c", "-L#{lib}", "-Wl,-rpath,#{lib}", "-lejdb2", "-o", testpath/"test"
    system "./test"
  end
end