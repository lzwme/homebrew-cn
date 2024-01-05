class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https:sqlmap.org"
  url "https:github.comsqlmapprojectsqlmaparchiverefstags1.8.tar.gz"
  sha256 "11ff3ec22c20f9df79ec9d008e2f17311a5e18930cc1feb4e4ad744271565916"
  license "GPL-2.0-or-later"
  head "https:github.comsqlmapprojectsqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8445df291d8c3aa4e8566469deef5450c27c5de3d17c4506451a98aea8e80036"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8445df291d8c3aa4e8566469deef5450c27c5de3d17c4506451a98aea8e80036"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8445df291d8c3aa4e8566469deef5450c27c5de3d17c4506451a98aea8e80036"
    sha256 cellar: :any_skip_relocation, sonoma:         "6aa8c80c9f1b893b668f00afc45181923d916b914093167317b3788bc475445d"
    sha256 cellar: :any_skip_relocation, ventura:        "6aa8c80c9f1b893b668f00afc45181923d916b914093167317b3788bc475445d"
    sha256 cellar: :any_skip_relocation, monterey:       "6aa8c80c9f1b893b668f00afc45181923d916b914093167317b3788bc475445d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03c5b0daf7f6e1921d46960f61565ae64d7523db73eea4a6b9f96e40ca7afa8d"
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