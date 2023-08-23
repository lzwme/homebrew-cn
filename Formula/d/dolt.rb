class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.13.0.tar.gz"
  sha256 "3950e263771ee3a53632459dc4bbeb8761db5be40d0bed542940f57fbf33c3f1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ef991190987c89cec38f9b022fd03e1c6824f3aa99a26fa4da38701d412f25a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ee3f4e6adb73fc3b3cae81b8d2ba456f7c74bed7365f6e02955b63114880237"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2ee8de75eea899fa6f259bf11613689cbcabcd26272fb2fe175982059c28301"
    sha256 cellar: :any_skip_relocation, ventura:        "50e55e8d5ef515e22b92f7040a67cabd597908a7626144a2f7bbfb899da947fe"
    sha256 cellar: :any_skip_relocation, monterey:       "1400bbadc67ac2e65f6de0de7ec09d598e65bd940a07a4003027251d8e6328e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e5fabb674baba7ac631885be297edeff73229d3c1eb7b48fe5737d74ce66c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8566f90123ae8029e53352ba9c9389f363ed8a9ab3150b06ea900151c89436bc"
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