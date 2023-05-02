class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://ghproxy.com/https://github.com/sqlmapproject/sqlmap/archive/1.7.5.tar.gz"
  sha256 "0bed6c991d02efa39deaa93293ef1183e6d54b63c1c12b585f5ffc0e9dee20e9"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be6b658d3f5222fbb25b9c502b1dc7d37426377722e0d4f8308055b73d4153de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be6b658d3f5222fbb25b9c502b1dc7d37426377722e0d4f8308055b73d4153de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be6b658d3f5222fbb25b9c502b1dc7d37426377722e0d4f8308055b73d4153de"
    sha256 cellar: :any_skip_relocation, ventura:        "625ac4f38ad63bd1e17810dd7dce2030eb67164f8064d33a20be04b24d9b0271"
    sha256 cellar: :any_skip_relocation, monterey:       "625ac4f38ad63bd1e17810dd7dce2030eb67164f8064d33a20be04b24d9b0271"
    sha256 cellar: :any_skip_relocation, big_sur:        "625ac4f38ad63bd1e17810dd7dce2030eb67164f8064d33a20be04b24d9b0271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "083d531ecd559bdc1c70b5aeeb7b0d62fb07935166d9c4a2bfc30a889ef72fbd"
  end

  depends_on "python@3.11"

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
    data.each_slice(2) { |n, a| assert_match "#{n}, #{a}", output }
  end
end