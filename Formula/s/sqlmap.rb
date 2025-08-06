class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://ghfast.top/https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.9.8.tar.gz"
  sha256 "11453be7421cc0a4d65d2ffc476bf3f135e4d4128249f382313b8dc7250d1382"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3502c9c0f94afb1c746b1265a85acbbd5d0b920cae215688aff67c03818f93e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3502c9c0f94afb1c746b1265a85acbbd5d0b920cae215688aff67c03818f93e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3502c9c0f94afb1c746b1265a85acbbd5d0b920cae215688aff67c03818f93e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ee62e761154303a0e8b3f93cd1ee0bb3e4aa43ffadf8c74cfa21f4b73bbd046"
    sha256 cellar: :any_skip_relocation, ventura:       "0ee62e761154303a0e8b3f93cd1ee0bb3e4aa43ffadf8c74cfa21f4b73bbd046"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf61512a0d78ff4a5da72eb81e14499c094d9ccab63fadf88878e634e01aa0cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf61512a0d78ff4a5da72eb81e14499c094d9ccab63fadf88878e634e01aa0cd"
  end

  depends_on "python@3.13"

  uses_from_macos "sqlite" => :test

  def install
    libexec.install Dir["*"]

    files = [
      libexec/"lib/core/dicts.py",
      libexec/"lib/core/settings.py",
      libexec/"lib/request/basic.py",
      libexec/"thirdparty/magic/magic.py",
    ]
    inreplace files, "/usr/local", HOMEBREW_PREFIX

    %w[sqlmap sqlmapapi].each do |cmd|
      rewrite_shebang detected_python_shebang, libexec/"#{cmd}.py"
      bin.install_symlink libexec/"#{cmd}.py"
      bin.install_symlink bin/"#{cmd}.py" => cmd
    end
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