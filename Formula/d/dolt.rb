class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.59.5.tar.gz"
  sha256 "0a7e57b46b4db1c21f48994885d2fb191da3892aa59371527019ea2fee0717eb"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c905f406d339b2271dbbcc4105d2a23d0f6a4410852807dc035fa1b831b72c0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddc64502f4850471c916830ff0679d96dd085a97e1f364812e087186a84f44fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa56b3e9dd93c9397b706084bd2f41a55a29863407ad5fd151261f389d381998"
    sha256 cellar: :any_skip_relocation, sonoma:        "4504fee3c2a1b69514a30503cab9b223e6c4133b496d8281b6252c4df4a2e923"
    sha256 cellar: :any_skip_relocation, ventura:       "b8f92a4205884fe38a73c6c62ca0e28a81d962f98e8633b20c33c7a6888fd96d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16e25ccfc8b541a5a3f693daecfe3334bb2be3f3e766a78e02524171c093e9a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2776a7defb01dedc88189fb867c31946272a71f9527f41c3a2ec852d72491c9a"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
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