class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://ghproxy.com/https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.7.12.tar.gz"
  sha256 "74c20a05ac2e66c5302f69e854769e4fd23d4af460cb0e17863306355f18c70c"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf913a61b176a135a08044d4752acd10af9636be08130a907f7f01e34d1ffc9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf913a61b176a135a08044d4752acd10af9636be08130a907f7f01e34d1ffc9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf913a61b176a135a08044d4752acd10af9636be08130a907f7f01e34d1ffc9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "18648a8a901094cf2f2a6295de0d6d2f0e7ee63ce8edcb69f2f5f1ec477bef3d"
    sha256 cellar: :any_skip_relocation, ventura:        "18648a8a901094cf2f2a6295de0d6d2f0e7ee63ce8edcb69f2f5f1ec477bef3d"
    sha256 cellar: :any_skip_relocation, monterey:       "18648a8a901094cf2f2a6295de0d6d2f0e7ee63ce8edcb69f2f5f1ec477bef3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70fced6cad0c4919d1dec7958cf464a90b4e1d5e7eab914eec24d76619833834"
  end

  depends_on "python@3.12"

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