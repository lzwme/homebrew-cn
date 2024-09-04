class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.2.2.tar.gz"
  sha256 "1495c1e8a16d2f22859be0d60e639873f94a7cc5a536ead3f7bc26ac36fb2e32"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "33267f0b6fc7cb7d079a953e44c53eec66014a716232f58ad4a66ba63a41bf4d"
    sha256 cellar: :any,                 arm64_ventura:  "bbc83ea803f8ef049bf2c889eb7ae2344de45e590ada563d31c4e3fc8b44d067"
    sha256 cellar: :any,                 arm64_monterey: "e792216b086872de58e75339585383f906d047146e1ca2255421f9566c5cff4d"
    sha256 cellar: :any,                 sonoma:         "475cfc414934c772aae6684d01bd8bf0d859c4bb8159a8a1bae37837c8a595f9"
    sha256 cellar: :any,                 ventura:        "9e91abe9e54d59e8c801d007c5bd2f5373274e16b56f7a7b22b9b2fef675643c"
    sha256 cellar: :any,                 monterey:       "d3647a4a44417b208a95f56db43e4f088de4439c37f3776899a16986ae35653b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb18fff9baa32134d1287eb1c2bad17a99e842d3914aa30471e7412d90ec45dc"
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    system "make"
    system "make", "install", "bindir=#{bin}",
                              "datadir=#{share/postgresql.name}",
                              "pkglibdir=#{lib/postgresql.name}",
                              "pkgincludedir=#{include/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgroonga\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end