class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.59.20.tar.gz"
  sha256 "4d6dded479299b8867070252a627b61d9b20f9e603a9b633db16c7b66a5e4df7"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c560acd05346eedf56a322747a5898ae5966c13740273fd24484de369766785"
    sha256 cellar: :any,                 arm64_sequoia: "2ed6023d57535fd32a56653abca22720ac2661895fe09cfb69fc093133e86905"
    sha256 cellar: :any,                 arm64_sonoma:  "d9b558ea272dab973439b344cfb6d97e5e3e0713fb858777fd1efbaaf4aa809b"
    sha256 cellar: :any,                 sonoma:        "67614005206d94c1fdfbb8f635466822b04d51c441d4787988f710b506cb2d6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4631b2c2ca667683592d6b23dd248692f59c790ba97e0ac03880609c0d05e220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83089c7916415dce1d07bc784c05ff4f34b319ec544eda5debf6a7baf64fdb41"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

  def install
    ENV["CGO_ENABLED"] = "1"

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