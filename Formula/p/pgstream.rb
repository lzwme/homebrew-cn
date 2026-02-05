class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e12d5b25d0c761e8457a0888a7dc4b7d007e3466304979eab3320df32863c7b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6974d9f82eebe99489dd404e24bbe1862f17480499dc65ccfd626deba043c42c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6974d9f82eebe99489dd404e24bbe1862f17480499dc65ccfd626deba043c42c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6974d9f82eebe99489dd404e24bbe1862f17480499dc65ccfd626deba043c42c"
    sha256 cellar: :any_skip_relocation, sonoma:        "da833fa7f9e4d883115399fade6a287ab768efd761700caee8d096ac53d044b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bd0ae909d8543addbd5ca307f6651441529009b101b82bd0bcd3f2b8e62a270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1e317df3ca2824d39345ab4b5b97f6d7285bd2ff965099ffaecdfe4ca008892"
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