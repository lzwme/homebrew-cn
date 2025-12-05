class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "b1c11659b34e0687a75957f45aec16442a8db798ae20dd671b2a6a04e2a2a9de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1dfca46afea8f9e526471daa4d18a629244697d60657e15e20f022e741b5197"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1dfca46afea8f9e526471daa4d18a629244697d60657e15e20f022e741b5197"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1dfca46afea8f9e526471daa4d18a629244697d60657e15e20f022e741b5197"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbdadb4cfb4c02aec4ce550cfd9bd03ada7c599d2ea99b071aba38ce7b80e1bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6beffa4cb723b8c29f6f6ac3022ceac8020fcb21cdb76d6ad37187966cdaf836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11cbd1fa8747a1c1dde0bdaf3948339185c8b74d0d4dd5c3092babd001f90d0a"
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