class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.59.15.tar.gz"
  sha256 "a03d571c95e9153b6eefd2c1af180b999b5fcff0ea6b2db0442727379775fd45"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "06439f96ab808c9eaa8e0e190b6d52968120ba093208328ec40354c3dfe3fcbc"
    sha256 cellar: :any,                 arm64_sequoia: "93eb55960d6d886be8032c0072e1a46556a926542bafbc6487fe0a0c9a86f53f"
    sha256 cellar: :any,                 arm64_sonoma:  "a198701f4d92023f47f46130215d9917f2de47c9dbaf1cceef32a4ea1f7f8b28"
    sha256 cellar: :any,                 sonoma:        "55d663aea0152c53c90dad46676d9d695d38e44dd360908e99f6f7253580a7c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de2de613675c8d46fc86841d4eef98f133efecf1ecc9e036a1fd3dca5821789a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "950d5f261cab7c18c432d231dae79d4f1be8f050fb0eb21dd536de72bf812e59"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

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