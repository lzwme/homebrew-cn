class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://ghfast.top/https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "0b5b7f35c8dd7da584831a389e22f7bd9809cc7f245ddd970758b4d7524eb5fc"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b329bc59f023f26df66f75160ab032d69ab3686475b3df363fae026fd81fd83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b329bc59f023f26df66f75160ab032d69ab3686475b3df363fae026fd81fd83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b329bc59f023f26df66f75160ab032d69ab3686475b3df363fae026fd81fd83"
    sha256 cellar: :any_skip_relocation, sonoma:        "41602a7a4fd9ba0c1cb46bf9be6dfa483ec9fe70a529a5cb7321f3e69471bdb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeec4de6004b94abb2b4eba14f969d2bfa4e070ec2edf12cb9e24307878ead26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abdac2b190258590b0b4a164dd854fbedc8969dbc5755dc14124f52ca0b96760"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    path = testpath/"school.sql"
    path.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = shell_output("sqlite3 test.db < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names

    assert_match "terminal not cursor addressable", shell_output("#{bin}/lazysql test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/lazysql -version 2>&1")
  end
end