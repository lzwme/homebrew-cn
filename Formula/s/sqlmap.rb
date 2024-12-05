class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https:sqlmap.org"
  url "https:github.comsqlmapprojectsqlmaparchiverefstags1.8.12.tar.gz"
  sha256 "3917a2a73a66dcaff76be5933e132d55e0e32f8a2b1690b9cf53eb413fd433f5"
  license "GPL-2.0-or-later"
  head "https:github.comsqlmapprojectsqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68dd79394ca2e3a447beb619bfe8ed77f374a59cfa57f41fb399028b9aa45270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68dd79394ca2e3a447beb619bfe8ed77f374a59cfa57f41fb399028b9aa45270"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68dd79394ca2e3a447beb619bfe8ed77f374a59cfa57f41fb399028b9aa45270"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aa1d780269e0c5b29ab952c0211caa5ed80792e665f0e532071238f77b258ab"
    sha256 cellar: :any_skip_relocation, ventura:       "0aa1d780269e0c5b29ab952c0211caa5ed80792e665f0e532071238f77b258ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87914cae7214d403699724f8943e05176ff14b564ad984115cc2a555974ea183"
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