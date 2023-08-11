class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.10.0.tar.gz"
  sha256 "64e25112ea2d91be2b15e4dbad9c06399ae0feb9df78acc8fa47d6c6d3c4adc5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49b7d05245f883373019c96f9748215a74fe39aa3eeed336dd58d09fa33bb942"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49b7d05245f883373019c96f9748215a74fe39aa3eeed336dd58d09fa33bb942"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49b7d05245f883373019c96f9748215a74fe39aa3eeed336dd58d09fa33bb942"
    sha256 cellar: :any_skip_relocation, ventura:        "68de365711f10cf0767cd34573ca7d878d4cf47505ea166b49bc6cdc1d19446a"
    sha256 cellar: :any_skip_relocation, monterey:       "68de365711f10cf0767cd34573ca7d878d4cf47505ea166b49bc6cdc1d19446a"
    sha256 cellar: :any_skip_relocation, big_sur:        "68de365711f10cf0767cd34573ca7d878d4cf47505ea166b49bc6cdc1d19446a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81db026e4a20c69cc7669d8cc2cef3398b2d7bddd89be3feb37e84939331ae37"
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