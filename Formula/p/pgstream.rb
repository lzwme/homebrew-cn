class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "7b037e04c50f0543efb71d800b0630dd8c1f76d992cc1fb724d317be8484523d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "311a2ebcd58708945b97cb22fb1809a629376fa22c6f624e8b7933af1a347090"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "311a2ebcd58708945b97cb22fb1809a629376fa22c6f624e8b7933af1a347090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "311a2ebcd58708945b97cb22fb1809a629376fa22c6f624e8b7933af1a347090"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dadaba7ac246a6e2897b2e83d585227eb9c2b6657f00666c45f8d2619ab4831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79369b0175d8b086afe6942501abb2a5ec7f31616e89f474f69c1a32beeaa599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afbca20a2dd25711e8618aa0b9223161ee9ebc27ff64f2be5c3d802654629515"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

  def install
    ldflags = "-s -w -X github.com/xataio/pgstream/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgstream --version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
      shared_preload_libraries = 'wal2json'
      wal_level = logical
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      url = "postgres://localhost:#{port}/postgres?sslmode=disable"
      system bin/"pgstream", "init", "--postgres-url", url
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end