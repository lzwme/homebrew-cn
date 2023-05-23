class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.1.1.tar.gz"
  sha256 "21af80a9ad4a28f4d244c6adb97b6e6c05c95304ff70757996b5bd1603f85cce"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02572fc22a9b6bb801a7071cbb85e4bda4159580dc2dd915ef1679a96964919d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02572fc22a9b6bb801a7071cbb85e4bda4159580dc2dd915ef1679a96964919d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02572fc22a9b6bb801a7071cbb85e4bda4159580dc2dd915ef1679a96964919d"
    sha256 cellar: :any_skip_relocation, ventura:        "5bb8e814c5a61fb96e4810dc1353b56a6e68023bfc11bb212ac96f6ec8015eef"
    sha256 cellar: :any_skip_relocation, monterey:       "5bb8e814c5a61fb96e4810dc1353b56a6e68023bfc11bb212ac96f6ec8015eef"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bb8e814c5a61fb96e4810dc1353b56a6e68023bfc11bb212ac96f6ec8015eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f85eabdd2a7b5dff88fc498ca83fdb7b39bc440900e72a5e03963bdca2271522"
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