class PostgresqlHll < Formula
  desc "PostgreSQL extension adding HyperLogLog data structures as a native data type"
  homepage "https://github.com/citusdata/postgresql-hll"
  url "https://ghfast.top/https://github.com/citusdata/postgresql-hll/archive/refs/tags/v2.20.tar.gz"
  sha256 "c78c7bde66bfd3b5873db85baf481cc798513ce87a5e3685625c8ad55b5be1ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbf5459380112349efbfe4f8aa143af045a9b7ab64cdd4c3a9f56d58845826d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92c66ce82d2aae8a39c3cd124f46ebfae009bbba60ff6bd4ac8cbae408b0e6d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f996014fc935ccf79b0fc3fca715d517dc9a7e56e7aaaf58d0cb8463c618d9f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d06e7a5d0a41d0d14b0cff1b46fb8d95d6887f38d239e0a0f15fefe6dd629fab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32802c95ae67c50ee896b5529afc8997fc0dd146062b12963d719415418abaa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5247f662b7f7d4cb0cacc28ab9aecb0d16303c0d4fabfddcfe0f004aee08dac"
  end

  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
      system "make"
      system "make", "install", "pkglibdir=#{lib/postgresql.name}",
                                "datadir=#{share/postgresql.name}",
                                "pkgincludedir=#{include/postgresql.name}"
      system "make", "clean"
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
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION hll;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end