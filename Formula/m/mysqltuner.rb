class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://mysqltuner.com/"
  url "https://ghfast.top/https://github.com/jmrenouard/MySQLTuner-perl/archive/refs/tags/v2.8.41.tar.gz"
  sha256 "0dd6dd5ef9d179569288acf6c6e076d9cdd1deeaa029beed107e966d04eeb27e"
  license "GPL-3.0-or-later"
  head "https://github.com/jmrenouard/MySQLTuner-perl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08a6873868be1a50c1dcc703a948a1846127eab45ed723f3db42d47f73501704"
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