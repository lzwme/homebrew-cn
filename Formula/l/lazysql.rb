class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://ghfast.top/https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f3250ef909f5a777611cb820081702c95f7965598f6d4afa2507668eefa5719a"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0916c5fe9f76015f2e475a87947f0bc50d9afc7da43ddd911329d069014f5b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0916c5fe9f76015f2e475a87947f0bc50d9afc7da43ddd911329d069014f5b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0916c5fe9f76015f2e475a87947f0bc50d9afc7da43ddd911329d069014f5b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8df065a9f09df8760fe33a390e939bbe401afae9532d620a7862b0d8fec748eb"
    sha256 cellar: :any_skip_relocation, ventura:       "8df065a9f09df8760fe33a390e939bbe401afae9532d620a7862b0d8fec748eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1843a190e372bcda4f36001bb80da7e05190dfbf51413afc185624cc2e66bbe"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite" => :test

  def install
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