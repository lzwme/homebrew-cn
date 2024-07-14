class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https:sqlmap.org"
  url "https:github.comsqlmapprojectsqlmaparchiverefstags1.8.7.tar.gz"
  sha256 "1f98ecc55775b35a302e92977ebba35e29a6a3e3d063982fac2816b954113aeb"
  license "GPL-2.0-or-later"
  head "https:github.comsqlmapprojectsqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d305ac82dcb1b18a108fac3d1d17b150046fd1227e1e004aa56cd44ba5fcfda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d305ac82dcb1b18a108fac3d1d17b150046fd1227e1e004aa56cd44ba5fcfda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d305ac82dcb1b18a108fac3d1d17b150046fd1227e1e004aa56cd44ba5fcfda"
    sha256 cellar: :any_skip_relocation, sonoma:         "b14c51c984388c40a923cc04a4d3a98f90a20055154c4814adfbdc55de662ba3"
    sha256 cellar: :any_skip_relocation, ventura:        "b14c51c984388c40a923cc04a4d3a98f90a20055154c4814adfbdc55de662ba3"
    sha256 cellar: :any_skip_relocation, monterey:       "b14c51c984388c40a923cc04a4d3a98f90a20055154c4814adfbdc55de662ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c93f7912f977a974d71c6f9c99b02cc6504bda78b0520f07795f9b7cb170784"
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