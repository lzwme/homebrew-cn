class ViSql < Formula
  desc "Terminal UI for SQL databases"
  homepage "https://vi-sql.com"
  url "https://ghfast.top/https://github.com/kopecmaciej/vi-sql/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "17843619fd6a71a1ccc687b29f6603dde800eec0c688026e0cc6a36720f9bd6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a4f4a73c0c012004e1ce3685caf46b5d85dd3318924c359f46c02e280e84f80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a4f4a73c0c012004e1ce3685caf46b5d85dd3318924c359f46c02e280e84f80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a4f4a73c0c012004e1ce3685caf46b5d85dd3318924c359f46c02e280e84f80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dce5ed47b1f69f738c9944aaf2c863cb71f95b260a7a8342de8bff10f85167cb"
    sha256 cellar: :any,                 x86_64_linux:  "95a1442bf0d42147f0a4b8db19aa10bc46b9087fa406c30df2a4291f2f207c46"
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