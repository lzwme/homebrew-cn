class ViSql < Formula
  desc "Terminal UI for SQL databases"
  homepage "https://vi-sql.com"
  url "https://ghfast.top/https://github.com/kopecmaciej/vi-sql/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "0fc9445c6c0bbadcd20c6033d417338910c550847f5f067e654ea4179390116f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "440173414cffff94f06b7d01072fdbdb633098b24208e7f3e2ea897553647382"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "440173414cffff94f06b7d01072fdbdb633098b24208e7f3e2ea897553647382"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "440173414cffff94f06b7d01072fdbdb633098b24208e7f3e2ea897553647382"
    sha256 cellar: :any_skip_relocation, sonoma:        "c690b59974f9149ef08f2362d2ed523cbea4ab7b0ba9c1db2e6892f1ac66edf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c478d3102f2522921e0c378098cb49a068dc50aa277155446331f7d146499fe"
    sha256 cellar: :any,                 x86_64_linux:  "e76ed71d7f1d94a7a15b4d862be17938643089dfd5f8c8117f1f17014d86cba3"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/kopecmaciej/vi-sql/internal/build.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vi-sql --version")

    test_db = testpath/"test.db"
    sql = <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    assert_match "Tim", pipe_output("sqlite3 #{test_db}", sql)

    ENV["TERM"] = "xterm"
    output_log = testpath/"output.log"

    require "expect"
    require "pty"
    PTY.spawn(bin/"vi-sql", "--reset-master-password", "--connect", "file:#{test_db}", "--jump", "main.students",
              [:out, :err] => output_log.to_s) do |r, w, pid|
      r.expect "SQL Editor Normal", 5
      w.write "\x03"
      sleep 2
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end

    assert_match "Master password is not configured", output_log.read
  end
end