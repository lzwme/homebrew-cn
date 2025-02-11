class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-4.0.0.tar.gz"
  sha256 "897bec794665a64f2d10a626d6bbf866674879c96a087cf3de37891fdd39d301"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6ebb7cc1419395b47bd4151d5e1d46a56315f244fe673a93a8581b0b1c8194e0"
    sha256 cellar: :any,                 arm64_sonoma:  "f367b6f03a3b653185bffa329bcce646d14ec5e226a868b897e0ec34235c291d"
    sha256 cellar: :any,                 arm64_ventura: "45f6fe81ea2ae78883dc0c18e7e77404a317b5927c209b9338666474634e0bfd"
    sha256 cellar: :any,                 sonoma:        "1186d63c63c8d3cf4ea201b6466de04c7dab8b1fc63cccc93ead8f655de77fb3"
    sha256 cellar: :any,                 ventura:       "1142ecc664b542b9185d2ca7e89d48328c403b8ad0639750e2b64c9727da2f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c9761366cb427b36bc494fee81463faa35a209eab68ebe11edc633bacf5a7b3"
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