class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://mysqltuner.com/"
  url "https://ghfast.top/https://github.com/jmrenouard/MySQLTuner-perl/archive/refs/tags/v2.8.35.tar.gz"
  sha256 "da1a1f4df611f46efee3acf190947afaebd6e6fe20b2986d849c3480aa63d48b"
  license "GPL-3.0-or-later"
  head "https://github.com/jmrenouard/MySQLTuner-perl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d66059306a9a633db5943a4f911bc2f4a7ec4e9428125fc814aacc9c40e4411"
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