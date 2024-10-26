class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https:sqlmap.org"
  url "https:github.comsqlmapprojectsqlmaparchiverefstags1.8.10.tar.gz"
  sha256 "8fee446ae72ecbe3d7ee583e3e77f3d352d3ee4f8e6ff33591a3f431387a10d3"
  license "GPL-2.0-or-later"
  head "https:github.comsqlmapprojectsqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d547c9c33f9657bad40118af4eb92430466e4ce6bd9136a48c2a93b809b86c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d547c9c33f9657bad40118af4eb92430466e4ce6bd9136a48c2a93b809b86c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d547c9c33f9657bad40118af4eb92430466e4ce6bd9136a48c2a93b809b86c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8074f3e89f7bcac08563d544864bdc311a52a75104651dbb89946b3a738f91d1"
    sha256 cellar: :any_skip_relocation, ventura:       "8074f3e89f7bcac08563d544864bdc311a52a75104651dbb89946b3a738f91d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "645816c6fd023df7e45da45498150b1b0ebba0fe2236c5619979543776072852"
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