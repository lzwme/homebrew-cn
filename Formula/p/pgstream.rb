class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "e7a61b1316ecd52ca132bc68480a629bf8c3665a605195815d2a1e0c60b7d0dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60b5559b0ec2f0ca83463110119299a84e65d964f8a662c1e9e1cf48daf93b3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60b5559b0ec2f0ca83463110119299a84e65d964f8a662c1e9e1cf48daf93b3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60b5559b0ec2f0ca83463110119299a84e65d964f8a662c1e9e1cf48daf93b3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d4be9f2499b152732cabb042000b296ae12cf848f43411dbdcb79b209886f65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f38641c349aa00d5bbcc323ff02de62f99e79ed1b1d7e8cf259089c859d2fe"
    sha256 cellar: :any,                 x86_64_linux:  "ad2a8cf9e1268dd52720724fb26a63b0487f1c05d85a3822c9f0b1043c5e673a"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

  def install
    ldflags = "-s -w -X github.com/xataio/pgstream/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pgstream", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgstream --version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~CONF, mode: "a+"
      port = #{port}
      shared_preload_libraries = 'wal2json'
      wal_level = logical
    CONF
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      url = "postgres://localhost:#{port}/postgres?sslmode=disable"
      system bin/"pgstream", "init", "--postgres-url", url
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end