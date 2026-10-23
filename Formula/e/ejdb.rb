class Ejdb < Formula
  desc "Embeddable JSON Database engine C11 library"
  homepage "https://ejdb.org"
  url "https://github.com/Softmotions/ejdb.git",
      tag:      "v2.94",
      revision: "46a79bffce059d0157319e166c365d29f99c4f35"
  license "MIT"
  head "https://github.com/Softmotions/ejdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8e3aaa609535862a02f0ccf6cd71617165dd6c1bc6cf4063a420d83c9e9d0e8c"
    sha256 cellar: :any, arm64_tahoe:       "4d39ef8d48beb0953074ed8d1714e1836c02dfbbcaa490949731b44e980ef40c"
    sha256 cellar: :any, arm64_sequoia:     "c167a662552bd08e0979173b3a6f1d4b109bf68384bfc13b6dc2467a0145877c"
    sha256 cellar: :any, arm64_linux:       "bf1738c7691bd07970f9c5cc299bb49df79bae757a93adc0ad8cefbe5f259224"
    sha256 cellar: :any, x86_64_linux:      "47fca7512b4b15676d62c4e21317dd92157c771f9d17820fb9b3d89ea04db097"
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
    sha256 "646babc72e905fe61e933ca78f3776341fea2aa3af8f5ff49dc4025fa1bb450f"
  end

  resource "iowow" do
    url "https://ghfast.top/https://github.com/Softmotions/iowow/archive/refs/tags/v1.7.1.tar.gz"
    sha256 "5d3d608099138c37f88bfe3b94c5b8e851584ff7767d695b140e47bfa24f95c7"
  end

  deny_network_access! :test

  def install
    resources.each do |r|
      r.stage buildpath/r.name
    end

    # Keep dependency libraries in Homebrew's lib directory on Linux too.
    inreplace ["iwnet.autark", "iwnet/iowow.autark"], "--prefix", "--libdir=lib --prefix"

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