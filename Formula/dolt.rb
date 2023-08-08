class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.9.0.tar.gz"
  sha256 "2d3a713cd4146f1b00af92b40f2ac1631f3e755dd7ad53be129c6700d5e0a1a7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f808892e67c0cf3eacf71e3816a143354f4456dcf8be0f8d4346e4b1d739f82b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f808892e67c0cf3eacf71e3816a143354f4456dcf8be0f8d4346e4b1d739f82b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f808892e67c0cf3eacf71e3816a143354f4456dcf8be0f8d4346e4b1d739f82b"
    sha256 cellar: :any_skip_relocation, ventura:        "f4ff6539bbbdea4fd5f48971c1b49deb8cc67599982966fb1564e43832459189"
    sha256 cellar: :any_skip_relocation, monterey:       "f4ff6539bbbdea4fd5f48971c1b49deb8cc67599982966fb1564e43832459189"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4ff6539bbbdea4fd5f48971c1b49deb8cc67599982966fb1564e43832459189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd5c8df183eb70f1fea7d9576e0650f0f20e581e17b2431ca2ee607ee61e0b2c"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end