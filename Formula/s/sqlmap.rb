class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https:sqlmap.org"
  url "https:github.comsqlmapprojectsqlmaparchiverefstags1.9.3.tar.gz"
  sha256 "02c01cb76d64f5459c34dfb2e5051d5fe57eab4d1af9f343e12c9ced43f33b99"
  license "GPL-2.0-or-later"
  head "https:github.comsqlmapprojectsqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8303fc167891834f69f1a57863f37fecfd33417423b17dd156e3eb55bc0c9fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8303fc167891834f69f1a57863f37fecfd33417423b17dd156e3eb55bc0c9fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8303fc167891834f69f1a57863f37fecfd33417423b17dd156e3eb55bc0c9fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba7733459ae6d57eb9212692c7f21af1f2aacae69bc100017df70c0b3a7e6c37"
    sha256 cellar: :any_skip_relocation, ventura:       "ba7733459ae6d57eb9212692c7f21af1f2aacae69bc100017df70c0b3a7e6c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "073411f48f7db2107e6907a77c7905fc2f62e8304dcf2fbea28f50bba475cb4b"
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
    data.each_slice(2) { |n, a| assert_match "#{n},#{a}", output }
  end
end