class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://ghproxy.com/https://github.com/pgroonga/pgroonga/releases/download/3.0.5/pgroonga-3.0.5.tar.gz"
  sha256 "e5c55f664d9b168a7f1108ef7ce6e237f005fe2bf70ea0c829bfc191b13229b1"
  license "PostgreSQL"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1e29cad0cb8ed0227578cbed5f40c4a09244b53f77554bae42df45750bcff4a2"
    sha256 cellar: :any,                 arm64_monterey: "299503443e29f8dfaa822435ee85ee877a269a8d47a397f10643795ec6f6b300"
    sha256 cellar: :any,                 arm64_big_sur:  "03d5b51950449ddd0b83b885972daf1106e144c29ea35fbec27d3a60171fe3d5"
    sha256 cellar: :any,                 ventura:        "de9da636cc474f2b130cf535d9fbc1f00103221a429de502ed1eb4608d7bde4d"
    sha256 cellar: :any,                 monterey:       "0ea57c7e4141dc85cdefeac06a0f29dd9a3d5f75d3c1aa48a5ae3f85ca9cf987"
    sha256 cellar: :any,                 big_sur:        "584530f4f313a14f6be299b6d478f2b51b1f20d0a540190bb6975020c2208709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b5ab2dafc4e34459c41ab5cbea14a92e9633abd214f066ebdcbcd1b384f49cb"
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