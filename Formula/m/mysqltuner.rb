class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://mysqltuner.com/"
  url "https://ghfast.top/https://github.com/jmrenouard/MySQLTuner-perl/archive/refs/tags/v2.8.36.tar.gz"
  sha256 "7ab5880f7462c173dbbc34353feb3fe6b9cd516e2b3a6bf1f82a615d55f34e49"
  license "GPL-3.0-or-later"
  head "https://github.com/jmrenouard/MySQLTuner-perl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2c29110fd935510b436dc6d7c3a6392e635d566445195178d192910215a91dc"
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