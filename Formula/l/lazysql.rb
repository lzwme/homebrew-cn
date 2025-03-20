class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https:github.comjorgerojas26lazysql"
  url "https:github.comjorgerojas26lazysqlarchiverefstagsv0.3.6.tar.gz"
  sha256 "50fed69c28d826fcb0b1f31bd68b3fe1a31c59ff71a0057ff0ae5e23069a914a"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d55cca2161919648ce910e302475f304062e42a4dc8991d77222a981f6384b1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d55cca2161919648ce910e302475f304062e42a4dc8991d77222a981f6384b1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d55cca2161919648ce910e302475f304062e42a4dc8991d77222a981f6384b1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d50ec643afdcb4982e095542b708486548bd450be04c70d06e02ac69af93c74"
    sha256 cellar: :any_skip_relocation, ventura:       "4d50ec643afdcb4982e095542b708486548bd450be04c70d06e02ac69af93c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a884a2761a598a0d6cc8a8b1bff2408a7d9e178692545c21dd5dcdec92bd97de"
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