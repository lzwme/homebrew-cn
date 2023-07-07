class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://ghproxy.com/https://github.com/sqlmapproject/sqlmap/archive/1.7.7.tar.gz"
  sha256 "ca478e7f3767ad584b34ea035ce8144d06d5deae4ea364df73c2916fd9922803"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "563c2eb6ba88378a532ed5fcf5fdad0955067ba44be06ba1854a0a13fe6c0f16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "563c2eb6ba88378a532ed5fcf5fdad0955067ba44be06ba1854a0a13fe6c0f16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "563c2eb6ba88378a532ed5fcf5fdad0955067ba44be06ba1854a0a13fe6c0f16"
    sha256 cellar: :any_skip_relocation, ventura:        "54ce062510fe8ae036fd3260a0efa5d8ed3ea9a9ef5053839d9e27394b1c83eb"
    sha256 cellar: :any_skip_relocation, monterey:       "54ce062510fe8ae036fd3260a0efa5d8ed3ea9a9ef5053839d9e27394b1c83eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "54ce062510fe8ae036fd3260a0efa5d8ed3ea9a9ef5053839d9e27394b1c83eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4252cd5b875e25258f8ccc8357dab68e8a613a7d1866be41f3ded9e6addc6264"
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