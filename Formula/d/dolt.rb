class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.57.4.tar.gz"
  sha256 "fc1d67b59284000949e7dcdb5546dea48a26158c8dc19974671b68e4d651af4b"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cba339a63199711b546dbadacc00bfee9b9f5bc83ea00abaaeee762edb7fe02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fed4969fd6ce7b17f06447c760ec878319b437617b3333b61d558c335edef72a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2be814aefe23f80aa7848540dbc8fea01776b6be076ce4c63ca1d1553b491ff7"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc708df63dfc18389dbd1715a9e2022b16549a2a1c4a9b182567cd2cea8e7277"
    sha256 cellar: :any_skip_relocation, ventura:       "7b36633b4c5a6e8cf74736c3cd82b541f48737ffd482cf71da3172647f10fd11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a19267e14730ddeb0187a6ee2f36cde56d764bc998b8ffb0a4287395b37ee47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "121630106aaad77e0f232ca92361b615c4ef43c16d8418ad8ee6769fc173740b"
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