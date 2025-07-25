class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.57.2.tar.gz"
  sha256 "ad8b568e02851a19bebafe5de2724767fc982c115750e496e38907c1c708c49a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46fd159fbea3400fd2c54b4e73b50bf609cd5658ba18e2fb1d70454453c5ba41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd15a5f3a45a695f13e7e59ecfad62bc83a41ea41d3396b53f5364e653375cfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eaa5749f88696702f36b2ba8eeb6905de578292a68d010a75f23bc137ef861b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "00f8989a062b74c72ecb8551484b1e793476c9af73cfdc8642a489e4319ddc97"
    sha256 cellar: :any_skip_relocation, ventura:       "a6793d3ff869a630e8a4d482ab4ee916653c49fa8dd6f74353460f924401c4c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ce6754c218d1d264acfea4cc179085cbeaaaa2cc4bef20f99fd9bbff6ae1f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff8410e7b1bb76ae21c46274f3d6de123227d265c799daf065513874561e51ad"
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