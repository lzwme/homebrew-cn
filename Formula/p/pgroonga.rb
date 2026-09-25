class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-4.0.9.tar.gz"
  sha256 "7d9fd0d8380ef0e807683c30ea25934e0bf5cfdc9553ad17a5907b620e0cbf72"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3bdf1ca0702137c0e9e5f163f5c28fd8161eb605fe94643eae5021974890cd66"
    sha256 cellar: :any, arm64_tahoe:       "0157e6102c4d83fbd10cb2c53230873b456db1d1634db200ab0157ebf0f0d4c8"
    sha256 cellar: :any, arm64_sequoia:     "c9f157043f4c074b8546b00823c148e9f8a8f184108204494ff4d3b18b7b4118"
    sha256 cellar: :any, arm64_linux:       "91b656670c82d0139339676e3915a299a3357a05aa7bfe94a4b2d6df6d477f0d"
    sha256 cellar: :any, x86_64_linux:      "74552185fa4d449d60d62c0c2ef72392732fe87f55162f26a0a71c47f863d7e3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]
  depends_on "groonga"
  depends_on "msgpack"
  depends_on "xxhash"

  deny_network_access!

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    postgresqls.each do |postgresql|
      with_env(PATH: "#{postgresql.opt_bin}:#{ENV["PATH"]}") do
        args = %W[
          -Dinstall_to_postgresql=false
          -Dtest=false
          --prefix=#{prefix}
          --bindir=#{bin}
          --libdir=#{lib/postgresql.name}
          --datadir=#{share/postgresql.name}
          --buildtype=release
          --wrap-mode=nofallback
        ]

        system "meson", "setup", "build", *args
        system "meson", "compile", "-C", "build", "--verbose"
        system "meson", "install", "-C", "build"
      end
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~CONF, mode: "a+"
        listen_addresses = ''
        unix_socket_directories = '#{testpath}'
      CONF
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-h", testpath, "-c", "CREATE EXTENSION \"pgroonga\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end