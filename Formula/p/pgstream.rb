class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "77386d68b090cbb607eb35b30628beea96d6175d7ea1136eb554039cda49fa9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce62fafc24b64e34bfc24e6e578e435a2eae310ae0e9fcc3dfa6eae09de99273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce62fafc24b64e34bfc24e6e578e435a2eae310ae0e9fcc3dfa6eae09de99273"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce62fafc24b64e34bfc24e6e578e435a2eae310ae0e9fcc3dfa6eae09de99273"
    sha256 cellar: :any_skip_relocation, sonoma:        "b03631b74839b818db1efdda3c94a384c94712e2c717382f197e5e3bcb43d761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "698e695bb0b6f04749820833b797d96a85c5cf3f7b21df764ba8eb49bf904557"
  end

  depends_on "go" => :build
  depends_on "postgresql@17" => :test
  depends_on "wal2json" => :test

  def install
    ldflags = %W[-X github.com/xataio/pgstream/cmd.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgstream --version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@17"]
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