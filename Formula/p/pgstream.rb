class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "051b793ac22297018d1b6ea156db4bc706b42fe1e788ee13183faf384bb8fca5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bb07d7a71bd1fd86cc9a326e8a59707215be02a238ab09a353b8e27046687f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bb07d7a71bd1fd86cc9a326e8a59707215be02a238ab09a353b8e27046687f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bb07d7a71bd1fd86cc9a326e8a59707215be02a238ab09a353b8e27046687f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ebbb33cc916c410aa3b7736924920ca4082bb8553b103fe0dba9c280f58536a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7732c07c27b51fd38b2fdf16277de9666466505733b527eb1a0f598e86508799"
    sha256 cellar: :any,                 x86_64_linux:  "12a6b4ff1d951a002f80dd3c61fcd195ae5fa1f231397b6b37d8ff4c093a54e1"
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