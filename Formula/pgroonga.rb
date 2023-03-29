class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.4.7.tar.gz"
  sha256 "b116cc3f2c96a23ff197619fd72b46e7b64e39e3fa1cbb1454f483aa1db607e6"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2a59a6d9879ce78f07d6be5580b475049454574865cc48d71e447c08e8caba2c"
    sha256 cellar: :any,                 arm64_monterey: "23e4b677cc8c7a68c782ecbafadde6c3b4d13d34cdebd9a78d6aafa126708851"
    sha256 cellar: :any,                 arm64_big_sur:  "175d538a752cdd9536cfd90fdb5235f6125e15a762dbaa397e0d44c5b36955ce"
    sha256 cellar: :any,                 ventura:        "de2fced3d5204e09cdf8bc1221927b342df7e32216e277b37968685dfc14c13e"
    sha256 cellar: :any,                 monterey:       "ab0939c1284479e2b3659de955b906995bd33b1485df5bfababa5dc938654ac5"
    sha256 cellar: :any,                 big_sur:        "5fbb26d212d9c799dc906931e36c5085646a448f5718d0f63341a6ca8548537e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98f916a77e5caa260b259dc255bea962560f2017d291f4519625c242f96221b9"
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