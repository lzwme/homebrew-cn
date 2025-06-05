class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.54.2.tar.gz"
  sha256 "112dd7ce67d052ad731c67d31e8e8ac6614fc491cda5993cb52d9478d1133ced"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "762b24748aed60cb7f0191e8d9fd6d2c4a9dc6c24727b88f85cf7638cb426648"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eebda6c665b821340b2475233d7946b9acce2a1934896abf88de5a44b86419d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8473000ece5e62b0f3cce7ffc71a9fba9be746e669255a01f17682123813857c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3c6454ae3a047d6fe7839b4acdce744f5c15b067e19b7bc04216f15cea20091"
    sha256 cellar: :any_skip_relocation, ventura:       "0d307d4ca85f8c3b2ee34b4b8289463636f7e62e5b3f621494abcc1332efb078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ce7e686bebcfee180737f568fdae2036522c08bc031874af0592b736c604b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e90bf00c70b4848da3660c3957cc7da8cc41f4125e3fdffff8f668a1814de203"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddolt"
    end
  end

  def post_install
    (var"log").mkpath unless (var"log").exist?
    (var"dolt").mkpath
  end

  service do
    run [opt_bin"dolt", "sql-server"]
    keep_alive true
    log_path var"logdolt.log"
    error_log_path var"logdolt.error.log"
    working_dir var"dolt"
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin"dolt", "init", "--name", "test", "--email", "test"
      system bin"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}dolt sql -q 'show tables'")
    end
  end
end