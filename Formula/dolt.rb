class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.2.4.tar.gz"
  sha256 "581c93486c45f4c2d4976d4cda94b66876ec60b3eb5c1aa6cb80685243fcc701"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72a3081de8cd2f7c966ddd6fac12ccfd1cc45a786f238412fa055ff74a9b88fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72a3081de8cd2f7c966ddd6fac12ccfd1cc45a786f238412fa055ff74a9b88fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72a3081de8cd2f7c966ddd6fac12ccfd1cc45a786f238412fa055ff74a9b88fc"
    sha256 cellar: :any_skip_relocation, ventura:        "90f810f77c1443380239a052dd6dc073d1c480b5e302e4a95db1d60966c93848"
    sha256 cellar: :any_skip_relocation, monterey:       "90f810f77c1443380239a052dd6dc073d1c480b5e302e4a95db1d60966c93848"
    sha256 cellar: :any_skip_relocation, big_sur:        "90f810f77c1443380239a052dd6dc073d1c480b5e302e4a95db1d60966c93848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dacb4f239beaf666bea85f7d1e91b256f6e5783437e98de2c74516d079288d91"
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