class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.51.1.tar.gz"
  sha256 "3f30a601f379dab357a697e4bd78b1a31a5f127d66c452f75b2e071c40636568"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e6b99ce4a1c846cc4a193ad8abb3dfd977b7aeab8d4d14126d0f1c2c0499128"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11330c993d2ac815db9f0c7179cd1bf59b6a80638f4643f55ab24d4dc67d2999"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "112be1fe425bbe5a99db7a79fa77b33925996ad0fc86e536eef72726e4a5075a"
    sha256 cellar: :any_skip_relocation, sonoma:        "867fa6ec74e3f7582f45659b412d464a156ffa3df87d7f8e4d44498ce63b2b08"
    sha256 cellar: :any_skip_relocation, ventura:       "f85d1e3201dbbb9b35e702a7e27813a261a532169d7f7c95f1e414bd4f669ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06e3bbf313c95ffeb99448de7785b92ff09d5f5859e8ee7e9898b2778795777a"
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