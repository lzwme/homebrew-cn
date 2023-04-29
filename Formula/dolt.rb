class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v0.75.15.tar.gz"
  sha256 "ec61890c77f10f3e9bba95cbabe36ef384b856cbcc1f6ae4fccdc2f3b6514ac0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a4b6e7f3df8487193b2af96b8d76e03847acda2e04e137815775765813adc7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a4b6e7f3df8487193b2af96b8d76e03847acda2e04e137815775765813adc7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a4b6e7f3df8487193b2af96b8d76e03847acda2e04e137815775765813adc7e"
    sha256 cellar: :any_skip_relocation, ventura:        "29a1081ff5681f83d46f41f61fc9ca6423d2f9cab70907ddabadb0c84d2cf8a9"
    sha256 cellar: :any_skip_relocation, monterey:       "29a1081ff5681f83d46f41f61fc9ca6423d2f9cab70907ddabadb0c84d2cf8a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "29a1081ff5681f83d46f41f61fc9ca6423d2f9cab70907ddabadb0c84d2cf8a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5d04cf195aa48ad080d61acea277705b7e47fe0480202a6d01fa56fad46235a"
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