class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://mysqltuner.com/"
  url "https://ghfast.top/https://github.com/jmrenouard/MySQLTuner-perl/archive/refs/tags/v2.8.38.tar.gz"
  sha256 "d98f8ec549f93be9f5be4c7af44bd1f45711817255b626b9786a549f801a55f6"
  license "GPL-3.0-or-later"
  head "https://github.com/jmrenouard/MySQLTuner-perl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f6ee58b42c4820efb18e3004c765e80368a09de825bdeed52aa7404b8dc6324"
  end

  def install
    bin.install "mysqltuner.pl" => "mysqltuner"
  end

  # mysqltuner analyzes your database configuration by connecting to a
  # mysql server. It is not really feasible to spawn a mysql server
  # just for a test case so we'll stick with a rudimentary test.
  test do
    system bin/"mysqltuner", "--help"
  end
end