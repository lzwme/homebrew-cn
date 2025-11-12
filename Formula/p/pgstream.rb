class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "9f04439b324f0c4eb2e889d20fdccc4dee6ea00558390c98d139eb96f417ce4e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6de29418be58d4f1d207a8d137631a9575d146b704e0f226916e84d289956f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6de29418be58d4f1d207a8d137631a9575d146b704e0f226916e84d289956f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6de29418be58d4f1d207a8d137631a9575d146b704e0f226916e84d289956f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b38e4b80951ba148bbfb765a2f17b96460377c36dd7c55a725f17baf0591b51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ef3475ed8bdc5ea4e8fa3ccc9449e62a8b8d1dc977bccada943a7d458e43835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd7b403d04e6c7c9f6d879d77d3f8f118c07fe0c846330097dd3feaa4f2b3ea"
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