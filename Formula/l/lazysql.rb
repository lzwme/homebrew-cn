class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https:github.comjorgerojas26lazysql"
  url "https:github.comjorgerojas26lazysqlarchiverefstagsv0.3.5.tar.gz"
  sha256 "402c1d123a6932cd04e2fe3a9e27b6d8be9be643ab68a6d247cd8b917ba5c502"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d07efab51493f7e3a039cdee493999928d9392c71373d2291fc7daebe1fae44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d07efab51493f7e3a039cdee493999928d9392c71373d2291fc7daebe1fae44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d07efab51493f7e3a039cdee493999928d9392c71373d2291fc7daebe1fae44"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d2760a77676ad342b39bf2baf698a335614b78ea465d6bc7c0e9d5b189fb9db"
    sha256 cellar: :any_skip_relocation, ventura:       "3d2760a77676ad342b39bf2baf698a335614b78ea465d6bc7c0e9d5b189fb9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86c622a395f246b4042845fc5fdc94561e837e21e3b709980a3b92f059f1231b"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    path = testpath"school.sql"
    path.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = shell_output("sqlite3 test.db < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names

    assert_match "terminal not cursor addressable", shell_output("#{bin}lazysql test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}lazysql -version 2>&1")
  end
end