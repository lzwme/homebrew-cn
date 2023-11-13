class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://ghproxy.com/https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.7.11.tar.gz"
  sha256 "49eb8d684f266f5a01a6f04a1b2e3f1776b32ea9b2359f16f90bee18fb57a9d2"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a38409ba3ae8e165b1e2109d9c29d9b9c014a0ce97720b2ddc211ad816785060"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a38409ba3ae8e165b1e2109d9c29d9b9c014a0ce97720b2ddc211ad816785060"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a38409ba3ae8e165b1e2109d9c29d9b9c014a0ce97720b2ddc211ad816785060"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ffe3ff8029f352f14d79e3058b9d9520406b3973dbfb76d5b2af6fdc922131c"
    sha256 cellar: :any_skip_relocation, ventura:        "5ffe3ff8029f352f14d79e3058b9d9520406b3973dbfb76d5b2af6fdc922131c"
    sha256 cellar: :any_skip_relocation, monterey:       "5ffe3ff8029f352f14d79e3058b9d9520406b3973dbfb76d5b2af6fdc922131c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "130d1c129be1c39c11783e6bf6a730cde23f1d0d2eb47f061d190fe9b5f7251a"
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