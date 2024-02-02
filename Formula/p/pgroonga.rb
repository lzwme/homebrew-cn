class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.1.6.tar.gz"
  sha256 "5df1e92acb6074143a3a8d1c0e93a985424d4eef4a81f06ec406bc45a76f8f20"
  license "PostgreSQL"
  revision 1

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4d64cddc5866536b2b92de4ae959171fe480cd79dd865e6f1dea302ea10b36af"
    sha256 cellar: :any,                 arm64_ventura:  "69318442e847942e565a8dbb45a6e942fb0630a3a799f312d29df10f1fce6e03"
    sha256 cellar: :any,                 arm64_monterey: "9f0a95c5ac7edb83333bef05bbe33e330520d27ef8d8255a16cc66ec1d5abe77"
    sha256 cellar: :any,                 sonoma:         "695f717f70e9a93a1992e28b5b86cbb490102f47a53848464a4885f678d6f9e5"
    sha256 cellar: :any,                 ventura:        "695a9fa5001d5a4f02a33eb3c178f0d96d3dbbe472ead126e21b1c5cb1091f0f"
    sha256 cellar: :any,                 monterey:       "38e4896381190478ae7ff3004c36f029ff2081bd58cc937798ee12cf59b92696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa846b787e72ccb0cb3aa2d1c40bbb5e3d4e29055d8437bb55be9d8fc8c6bd66"
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    system "make"
    system "make", "install", "datadir=#{share/postgresql.name}",
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