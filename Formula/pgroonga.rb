class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.0.3.tar.gz"
  sha256 "0c54af17afcf7c18e1a3aafadd5d5f7706a9fbcaebd56f4a38664847608e5c97"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d89d107dba1f927aafcae35c83aa26601bb0079de82fe6d8a8bf59c1997c6d38"
    sha256 cellar: :any,                 arm64_monterey: "4f7c671a46297c29d4b313e20c14d4456ed9802df8a6da9d60726cb8e0b7998a"
    sha256 cellar: :any,                 arm64_big_sur:  "3079f3cd2332cd033e20871ce865bd3f5fcc411f4a0c479160f75f15194449c0"
    sha256 cellar: :any,                 ventura:        "ca92e649821c88242c326692de5c73915d9a0e497f904798f348ce57d74288ea"
    sha256 cellar: :any,                 monterey:       "042c58d34361853108837343a3a6f6c6efdfdb897fc4d60e7cf7c9caf6177281"
    sha256 cellar: :any,                 big_sur:        "660f5378a54c0873e92c3d8a7253ba4f2454c7163c7944f8f33843fd48853e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a4e0e33d1999ae0ea6c8bd65caa5e47bf06897df5619933b60eae85f97818e6"
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

      shared_preload_libraries = 'pgroonga'
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