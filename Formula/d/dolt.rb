class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.12.1.tar.gz"
  sha256 "f34d7dc011a1f7b7cb97df693b1640dae0e7f45185123b4b720a748363329863"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ffb35e482281ef665d09cb85dd6dfa1c48d03e365ea5de5a11bf00f39acd5d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0423488d85af65fed4c8c0a5f6adc6eb5a928c3c8ab325f9797ddbfa64eec456"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed7e2f72db051306040fcaba6f0188609fb6b23df68a8fdf504d099d2d90bd12"
    sha256 cellar: :any_skip_relocation, ventura:        "3c9385ee9af92589fda329fea06045415eae1fc20a3f7011c5f55ebbdb04304a"
    sha256 cellar: :any_skip_relocation, monterey:       "5c0392fa11b3f7646e64744366531fb71d08d582bc3d2c14fe4fe58d89bbfac4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cdccf8403f167e25fdaedd93e53aec02f1fc883a91084dd169ce27eac554390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72c6455f2eb131d3e64a30f8354d2afed770d3fadbd9852a850bedfa29e41e89"
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