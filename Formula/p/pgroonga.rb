class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-4.0.2.tar.gz"
  sha256 "2c121978b610efb50ee8919184fa69c06fff1c16af1502c77f37367817d06823"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a0d34a15dfc6e50d4683cf53c2550b1b44f979c79104bd3cdbb63116e7f5499"
    sha256 cellar: :any,                 arm64_sequoia: "9be6e14234a91733d53540dde22267a8ff42d0e1dfb5ef6260c196b64983c23d"
    sha256 cellar: :any,                 arm64_sonoma:  "6e8235da975501e02f20faaf99263acb94d298b681eac6ee6cfb9cbb02f1c50c"
    sha256 cellar: :any,                 sonoma:        "c88d25354070b5f16a3db6312352f967a67f450d24ed5990a76843612573c5e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a9fce0bb73619d7e104f2a5636fce7d942acb1cef7dd0824a7ff574bc9d4bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cddf003fce89c699dffb8025792d378d2b33077e698c11af59fc7a2db97f281c"
  end

  depends_on "pkgconf" => :build
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