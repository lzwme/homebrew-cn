class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://ghfast.top/https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.9.8.tar.gz"
  sha256 "11453be7421cc0a4d65d2ffc476bf3f135e4d4128249f382313b8dc7250d1382"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "933d2d0b66f7ed1699d98be08c2726691e23ac457817e5487af3d970ffbcd752"
  end

  depends_on "python@3.13"

  uses_from_macos "sqlite" => :test

  def install
    libexec.install Dir["*"]

    %w[sqlmap sqlmapapi].each do |cmd|
      rewrite_shebang detected_python_shebang, libexec/"#{cmd}.py"
      bin.install_symlink libexec/"#{cmd}.py"
      bin.install_symlink bin/"#{cmd}.py" => cmd
    end

    # Build an `:all` bottle
    inreplace libexec/"thirdparty/magic/magic.py", "/usr/local/Cellar", "#{HOMEBREW_PREFIX}/Cellar"
  end

  test do
    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)
    select = "select name, age from students order by age asc;"
    args = %W[--batch -d sqlite://school.sqlite --sql-query "#{select}"]
    output = shell_output("#{bin}/sqlmap #{args.join(" ")}")
    data.each_slice(2) { |n, a| assert_match "#{n},#{a}", output }
  end
end