class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.1.5.tar.gz"
  sha256 "75d25efb7975d4ee6f5df4b3213d37005e9e91598640f568b39e1d4a98d09e92"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1192b2a3057c8e9bd18d7765fd7383ca26bae5f6851799200fa87b85d3f92f0d"
    sha256 cellar: :any,                 arm64_ventura:  "60f6332508015a6a517a61988667b59fae0a882926be3fef38690aa3beeb7463"
    sha256 cellar: :any,                 arm64_monterey: "40fc6e5f636945712519f74dca3800ac51454bfc4a7599fa9a8244b84ef67c9b"
    sha256 cellar: :any,                 sonoma:         "71495e6c6e8b24ac1ccfdc65cd1ed62efc833f3c35a0d8a524289b1cd89bf1db"
    sha256 cellar: :any,                 ventura:        "d3d6f6c0e4e16e8e34d52d61aec652b2c95f7740eb663f2341f3d551b04956b9"
    sha256 cellar: :any,                 monterey:       "261a6f045c9038831334cb75257a4161f6737df41fcf8c782cc4a3fc5ca7cac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43c70b1819f77c31c565c015e2a1a5c6ce499a82bd3879a718388dc44a72c76c"
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