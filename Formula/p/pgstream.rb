class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c808f5b8a75aa52e486ba6a92a2b4d53edce4ff63ec2336b980b20b4babd03e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44a9bd74387168c700ddd17be617b75d46717629791b718dab6f5637965ce59d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44a9bd74387168c700ddd17be617b75d46717629791b718dab6f5637965ce59d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44a9bd74387168c700ddd17be617b75d46717629791b718dab6f5637965ce59d"
    sha256 cellar: :any_skip_relocation, sonoma:        "70b8c4f7de9be0d320b94d0f563320bc78146bf0e8faad956f6c2d5e0215f7a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ed2612b7e7d4ce08bbf2febe0a249f87c5501c8d4497dbe8a2b182828cd86e3"
    sha256 cellar: :any,                 x86_64_linux:  "8e5f1546424f39570c32947298e189f9c25a60d655f005188b8e4eaa4d462005"
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