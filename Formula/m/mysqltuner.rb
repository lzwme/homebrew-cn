class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://mysqltuner.com/"
  url "https://ghfast.top/https://github.com/jmrenouard/MySQLTuner-perl/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "f8fc665bdc294d68aa77bd2328186e73e53d62e6ae59b33a2d9633786f55c3e4"
  license "GPL-3.0-or-later"
  head "https://github.com/jmrenouard/MySQLTuner-perl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a552fdc948b014683ad6fa099d6681e2c573b38b0ffb01efed09be9b830dfd2f"
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