class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "601c118abafa5a63ef20ded0a4220f2c028c59bb1b63f41b544f7d20a59c265b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa02a9724bc862c54ff875f864b4ac9bb37cfc3210f53578fa20549f97f3b791"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa02a9724bc862c54ff875f864b4ac9bb37cfc3210f53578fa20549f97f3b791"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa02a9724bc862c54ff875f864b4ac9bb37cfc3210f53578fa20549f97f3b791"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b21caa2452786c261964d42f8d1976bd0fe7a183d4e2f5b5ba91987bf542a58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89e328b28903feb44b014b43c1cf1c757433370b06da997f734e5fa0b08e7fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "948f662c6e544dfc61563a8a0ef1ff450d125e76bd4646488e64aa15ca8fdcb7"
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