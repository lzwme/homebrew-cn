class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https:sqlmap.org"
  url "https:github.comsqlmapprojectsqlmaparchiverefstags1.8.11.tar.gz"
  sha256 "e52ee3a3c1892745176f936fc16a7f761d690739afa4b7b01c64e9144849cbd9"
  license "GPL-2.0-or-later"
  head "https:github.comsqlmapprojectsqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edd9e5f42592cf45e4015b7cb01c8d037d1a7d0587dd89caae95ce71c6cc0502"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edd9e5f42592cf45e4015b7cb01c8d037d1a7d0587dd89caae95ce71c6cc0502"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edd9e5f42592cf45e4015b7cb01c8d037d1a7d0587dd89caae95ce71c6cc0502"
    sha256 cellar: :any_skip_relocation, sonoma:        "be89b153d6ae2e1f91ba453a630235de9cbe37f44e53c0f70bcd638ef983f980"
    sha256 cellar: :any_skip_relocation, ventura:       "be89b153d6ae2e1f91ba453a630235de9cbe37f44e53c0f70bcd638ef983f980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9ac3eb74c8d5ab50ff9d671834b5d71956ba3845890aed11e017d8459836d00"
  end

  depends_on "python@3.13"

  uses_from_macos "sqlite" => :test

  def install
    libexec.install Dir["*"]

    files = [
      libexec"libcoredicts.py",
      libexec"libcoresettings.py",
      libexec"librequestbasic.py",
      libexec"thirdpartymagicmagic.py",
    ]
    inreplace files, "usrlocal", HOMEBREW_PREFIX

    %w[sqlmap sqlmapapi].each do |cmd|
      rewrite_shebang detected_python_shebang, libexec"#{cmd}.py"
      bin.install_symlink libexec"#{cmd}.py"
      bin.install_symlink bin"#{cmd}.py" => cmd
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
    args = %W[--batch -d sqlite:school.sqlite --sql-query "#{select}"]
    output = shell_output("#{bin}sqlmap #{args.join(" ")}")
    data.each_slice(2) { |n, a| assert_match "#{n}, #{a}", output }
  end
end