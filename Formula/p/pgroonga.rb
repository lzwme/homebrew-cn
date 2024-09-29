class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.2.3.tar.gz"
  sha256 "93df838222f3536700de3bf0de9305eff1660c6c6c098b4039a52d7f62cc4e7c"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5cb2d9f25149f25bcdac03224fc611916ff283cf3cfbb11d548e32a7e5b852ee"
    sha256 cellar: :any,                 arm64_sonoma:  "46711e110276f4fb5a9246abccbe99e7d4f5aa3c19332955a3ab9ef282e9f697"
    sha256 cellar: :any,                 arm64_ventura: "13babb327a1e856b0242e20f7745bbf34c66e12d856f9177a0db1547cef62211"
    sha256 cellar: :any,                 sonoma:        "3887bc78ddcbc5cf27393216e06f8f938dc495973d64ea1a016683f9a4ba3650"
    sha256 cellar: :any,                 ventura:       "96ec1d2238e9ef73652894e8228450e23298ceffddd5e3052753f04b0f825451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c5ab20f474e559474eae8cf5180dcb1aa3d7364ec418c19f4081c75c7c78ffa"
  end

  depends_on "pkg-config" => :build
  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]
  depends_on "groonga"

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    postgresqls.each do |postgresql|
      with_env(PATH: "#{postgresql.opt_bin}:#{ENV["PATH"]}") do
        system "make"
        system "make", "install", "bindir=#{bin}",
                                  "datadir=#{share/postgresql.name}",
                                  "pkglibdir=#{lib/postgresql.name}",
                                  "pkgincludedir=#{include/postgresql.name}"
        system "make", "clean"
      end
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgroonga\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end