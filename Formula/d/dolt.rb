class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.83.5.tar.gz"
  sha256 "9032cb0b884c14b5868f2224ce218f76d3a073ccfcd0389877b3b521cdf4f1a8"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b393e98e29dda3f80ed95750eb55b07d313e723d9322da46c55987cb533b8012"
    sha256 cellar: :any,                 arm64_sequoia: "240a00514a81038e5a854bb1b2cc4c5de3557fedda22bf447982a5f19bc91b3a"
    sha256 cellar: :any,                 arm64_sonoma:  "c3837bff278b57c42d28d4cf32ea0fdd3149fbccb061fb5837f3cdb8e5e68402"
    sha256 cellar: :any,                 sonoma:        "2c4fe586dd289fcbcdd3f0b26d148a36ee7864a312f85fe12bdc0538eb05e2d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a1140332f426692200003f2e7fedb4f0e103740ac03e5c40ce55f00ee60c318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a377744c15b317b7355c8674ac06cfab095e5d2c09572241bfa7476ace1bc447"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
    (etc/"dolt").mkpath
    touch etc/"dolt/config.yaml"
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
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