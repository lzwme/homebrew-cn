class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.51.4.tar.gz"
  sha256 "8cd4b4a6ee0e55f4cde7206c1b9e1f9c00302972f17112b505ccf6d58e6fbc74"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18a413c2990780a1b64d3d63e2a62eed958ae42a887c61f35bbd5a4cc1d6a7d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea355c9004356e11485be8d0d27f0376a687f291758cdd25bd4e42707ea96099"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0306fb5f2c8c264bfa0ecb0aaf9ee4238e4706379640157b1316581e3242483d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbccd731ce48e4e139ddc700674311e6f092165833a08636fb1a8feca851cd48"
    sha256 cellar: :any_skip_relocation, ventura:       "63069cc648992c61a036eaddf9d4b599fcce0240ada4455ccdf2c261bff528fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28d2875cb34c9f299798b692ffd14d68a16e7920e7c6743100f35bacef5fd681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "847242263251ea5fa72ebfa47b60ec6b8b649ef3a1adf56c1c620c2c477b2478"
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