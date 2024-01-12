class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.1.6.tar.gz"
  sha256 "5df1e92acb6074143a3a8d1c0e93a985424d4eef4a81f06ec406bc45a76f8f20"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "da1d2e4b28667bb1ce4d65e36da22e758c3708a57c30e2240c038c339745d0cd"
    sha256 cellar: :any,                 arm64_ventura:  "1032f4f6c1866e14ab8703267651a088e9d54962e5b64a5b735974a7ec1888b4"
    sha256 cellar: :any,                 arm64_monterey: "5d04adc3271ba005592e9653355c79c17ea92d6f67a879c45e266fc2d442aa75"
    sha256 cellar: :any,                 sonoma:         "c7afe3c651f623c951386a88e8d315192ef57b7b8ac42c2cc58591a26a39f5ba"
    sha256 cellar: :any,                 ventura:        "ba122c0a74ad65bf726fc98ab7820c35b00bbc98e4d6029ebe8fce273dff7cc9"
    sha256 cellar: :any,                 monterey:       "27ac7c0c6f308aa464979ef010767f23c1273030ca1dc7bcb6d4da91f5e62928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99bfc2b18b5b6d1227e68422c976576513e3a2e005c49d253a16ba0f29b7b3e7"
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql@16"

  def postgresql
    Formula["postgresql@16"]
  end

  def install
    ENV.prepend_path "PATH", postgresql.opt_libexec/"bin"
    system "make"
    system "make", "install", "datadir=#{share/postgresql.name}",
                              "pkglibdir=#{lib/postgresql.name}",
                              "pkgincludedir=#{include/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_libexec/"bin/pg_ctl"
    psql = postgresql.opt_libexec/"bin/psql"
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