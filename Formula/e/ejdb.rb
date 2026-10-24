class Ejdb < Formula
  desc "Embeddable JSON Database engine C11 library"
  homepage "https://ejdb.org"
  url "https://github.com/Softmotions/ejdb.git",
      tag:      "v2.95",
      revision: "3ed77af15559da8d3fe29ff3ff0c188ce6faf421"
  license "MIT"
  head "https://github.com/Softmotions/ejdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a63013a9253e215e08e5a4f7b608939f8cb8f75aefd09e8022a6bdaede715278"
    sha256 cellar: :any, arm64_tahoe:       "1e0034881768947319526fcdc5be14f64e3a8ac402b49c77377aeb2c73894e7c"
    sha256 cellar: :any, arm64_sequoia:     "73b659b327e6c72007c5afe095799a240e3605ec767954dcd0487549e84c6837"
    sha256 cellar: :any, arm64_linux:       "91a2b3114deb091fa0ac3194d4144c21905d7c511c86cdc8f37893838ebb2c0c"
    sha256 cellar: :any, x86_64_linux:      "9fdd1ec972d6536db30d3b659153a08e65d732af7b4ae9916c4d82f0f15633de"
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
    url "https://ghfast.top/https://github.com/Softmotions/iwnet/archive/refs/tags/v1.4.1.tar.gz"
    sha256 "43428ea216ac1bb461833e082924e0302b21cfc172de377395d0bdbda6d1be8a"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/Softmotions/ejdb/refs/tags/v#{LATEST_VERSION}/Autark"
      regex(%r{/iwnet/archive/refs/tags/v?(\d+(?:\.\d+)+)\.zip}i)
    end
  end

  # iowow is pinned by iwnet rather than ejdb, so follow iwnet's default branch
  resource "iowow" do
    url "https://ghfast.top/https://github.com/Softmotions/iowow/archive/refs/tags/v1.7.1.tar.gz"
    sha256 "5d3d608099138c37f88bfe3b94c5b8e851584ff7767d695b140e47bfa24f95c7"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/Softmotions/iwnet/refs/heads/master/iowow.autark"
      regex(%r{/iowow/archive/refs/tags/v?(\d+(?:\.\d+)+)\.zip}i)
    end
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