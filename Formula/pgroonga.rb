class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.1.0.tar.gz"
  sha256 "fd020a911ec223f5288e99131c91abb437a9a0aa9d5e51b8fdb96d633bd61fb9"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "35289d966a5e09a8bfd2ce1d0e10a5c7091ff132c2bc235388bf964ab30d8377"
    sha256 cellar: :any,                 arm64_monterey: "de7d52b93fd57c6e8a1fa30273b395d66e26c06d54a856d4e47167fd699d1267"
    sha256 cellar: :any,                 arm64_big_sur:  "2dc3b10ed092f2ad208314fce673fd416dbe3c8395361baea71bb2052df3cd35"
    sha256 cellar: :any,                 ventura:        "c42e1cb6772405cfb370bedaac24cf262493d2b3d183036171a65c7050fec293"
    sha256 cellar: :any,                 monterey:       "58810b77c72e83040613d4d99bb3362331bf4d59cb94d8532ce7cd1054ffcfd2"
    sha256 cellar: :any,                 big_sur:        "965e0a7fbc2a6adf21249086009aa461026f7433671f59ed056bf508d4ccd96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c6e8b6587738ce5dcf66a082353f8b2e12161485afc7e25183285e256621ba7"
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children
    include.install (buildpath/stage_path/"include").children
  end

  test do
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