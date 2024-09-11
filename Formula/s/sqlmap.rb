class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https:sqlmap.org"
  url "https:github.comsqlmapprojectsqlmaparchiverefstags1.8.9.tar.gz"
  sha256 "3ae9969bec583d21790c5282aa3e586bf8fa822ad5d267afb7ea19db07ac434c"
  license "GPL-2.0-or-later"
  head "https:github.comsqlmapprojectsqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4ff43f4471f18c62e28b93dfc9d9da66cefa3fad83251c3819c5c3a736cdf6f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ff43f4471f18c62e28b93dfc9d9da66cefa3fad83251c3819c5c3a736cdf6f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ff43f4471f18c62e28b93dfc9d9da66cefa3fad83251c3819c5c3a736cdf6f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ff43f4471f18c62e28b93dfc9d9da66cefa3fad83251c3819c5c3a736cdf6f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "79e8fa29f56e9134c35ec67407febdb7e5a369d6699127c448c23f20fbb678a4"
    sha256 cellar: :any_skip_relocation, ventura:        "79e8fa29f56e9134c35ec67407febdb7e5a369d6699127c448c23f20fbb678a4"
    sha256 cellar: :any_skip_relocation, monterey:       "79e8fa29f56e9134c35ec67407febdb7e5a369d6699127c448c23f20fbb678a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eb774f28e6e51f3d4e8d5ff1f17c4914a961ed1bf2add2156b53967716eed80"
  end

  depends_on "python@3.12"

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