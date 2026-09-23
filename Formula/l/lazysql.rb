class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://ghfast.top/https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "f7d6bd4dfc9f7b72d2fbae076dc8d8c05773a970978a4e9ac3458dfb393c3f33"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5da0fc1695e78c0390d639add0f7c794efaa8468467c65efb15110cfc950c14f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5da0fc1695e78c0390d639add0f7c794efaa8468467c65efb15110cfc950c14f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5da0fc1695e78c0390d639add0f7c794efaa8468467c65efb15110cfc950c14f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c6ff988088984c5f2732eaea47b717df438959aac3b219fa67ef8ab46cc34e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f47900b38e8cb9cee6e308b4256b1f7d0b3dc506a78b44fb286cc1c40b190103"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    school = <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = pipe_output("sqlite3 test.db", school, 0).strip.split("\n")
    assert_equal %w[Sue Tim Bob], names

    assert_match "terminal not cursor addressable", shell_output("#{bin}/lazysql test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/lazysql -version 2>&1")
  end
end