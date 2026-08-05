class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "d7fbbe13472f315e5f259089bb9a1cefea12d5d85e8f31833a04722633c1dc8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d977e498b31ae40f5add52427ff8077d216321a3d6451ded01d196874bbd2fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d977e498b31ae40f5add52427ff8077d216321a3d6451ded01d196874bbd2fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d977e498b31ae40f5add52427ff8077d216321a3d6451ded01d196874bbd2fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ceca387023c58d59da1aa8121a9a6f3b1de5fa9be92b1ff7279ae3d19edc689"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d6654409a61174e47b2b3bd585e8452ad5770b48b736696f64a5ceaa74143dc"
    sha256 cellar: :any,                 x86_64_linux:  "768dfd4cd71f454d7d252be4114d06f5f99093127b1bcad23bbbf8ef3188d469"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

  def install
    ldflags = "-X github.com/xataio/pgstream/cmd.Version=#{version}"
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