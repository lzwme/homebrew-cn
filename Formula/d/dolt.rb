class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.76.0.tar.gz"
  sha256 "0d717ffa11de8da14174bf1e6219618c0ea4716b6dd9edeacd6510926f006c16"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f768177bff3658c7f6edb263452fe8056921a6cff9745a5111593bde788584d"
    sha256 cellar: :any,                 arm64_sequoia: "8ec898deb638e4fad3e2270ec70c56118566f7c121dea85b3e62ae881b57eec0"
    sha256 cellar: :any,                 arm64_sonoma:  "2b08a3691458e4a24c6a04f8b3d559325b3e84fb006d31fb63601046cc37df7e"
    sha256 cellar: :any,                 sonoma:        "96722aaca81bed621ae84237e0d90356639239ccf4d5ad67a10a0abfcbfcb4cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e334b97a2e18be3f823362208fef7f422d4a8a5e04ce0870883ecebcf762ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40d39a9a7d1b6312445b36a014d415a3b2fed4cf375f9b1e86a36047d7202f1d"
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