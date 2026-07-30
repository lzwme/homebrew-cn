class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "23183591526c3536399eddb58dd862a628df209413a886e064fd0214de0dce9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b835e425dbaf1f888831e728eb8caa002d203821703d1d3c8f1a18380adbbb86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b835e425dbaf1f888831e728eb8caa002d203821703d1d3c8f1a18380adbbb86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b835e425dbaf1f888831e728eb8caa002d203821703d1d3c8f1a18380adbbb86"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c59a192242369808119e4d732b71e28b0a9160510c47ce817a4ad0ebaef0df3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "672fb5bc4376da213bf6e3af3b08d23bd7224c968bc5391b9766b7c7de48e090"
    sha256 cellar: :any,                 x86_64_linux:  "50e06eb8d95aad189dd8450fc37ba2664b8248e762b4eb4f8eab18ecc9fc01c2"
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