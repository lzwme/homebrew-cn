class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.76.2.tar.gz"
  sha256 "b62bedb19657c0ce1036b87680095f9acc05ad04be35fbe488cd6caf3e5546df"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e516821d59b1346cdd37a2b14132fb345adc0d54e9657804437f5574fd69cb5"
    sha256 cellar: :any,                 arm64_sequoia: "bab75331a52d73651fbac3db5474e53ab242985a7a5f2d37089894298abe4b20"
    sha256 cellar: :any,                 arm64_sonoma:  "d573ddd2aa3afda0ac749059d432dc6c2b5aca05b14cb98b1bc7ea794d524ace"
    sha256 cellar: :any,                 sonoma:        "2fcd495e9629fc8900171cda3274506b735d6944cff5cf506fdd21f52259731e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "746d5e23bd40abc5968651c27e0d0ff096dc3d2482b6b65a20613a298d89fba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "692e5b252ca27d20d027d3a03b56ebabca53b225cac3e8ce2db86314bc5b841e"
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