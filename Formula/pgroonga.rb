class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.1.1.tar.gz"
  sha256 "f404c4c286993685801ad63346bbc0c6c483bab9245f580fefa4390eb4beac6b"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76ce20dc2a68839d52992d99ec8e088c4c1481bd374b6b0c43eccccafeadc1fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c249038bdb7cb0c9d65c81c84d82d45910976e1c76cc56bc65637e2270d05f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed3aeae9737fd9e1f10dde9c1a21f803b0e30f45118cea87a13c24c4a71a7278"
    sha256 cellar: :any_skip_relocation, ventura:        "1259bdcbc8bc658d3945f1bc7162579c8a137eb2321ccd8ec8a5b6de969960c7"
    sha256 cellar: :any_skip_relocation, monterey:       "c46b1b7a016b1973e257798a1090be60a60c724dcbdcf509f022a8ca4749fa5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c717a5dc8dc37d23592c12ea8dddbd76903a647604523a7547963b2a68f64a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d29c5cf4c415e54d90394dcb0baba42dd1efdc03858c4d883d8a0f5b2ab7d40"
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