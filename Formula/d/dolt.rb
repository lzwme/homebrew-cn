class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.58.7.tar.gz"
  sha256 "87fd7243386831abdc9d63aa848ebb9748796a55f9968fe31e392688ea1a3326"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fbc009c1d4e951ad41931778b76ba565c9c66bffcaf894be96b15693918e598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5138fc4afe8563eb6da6b61040f0fec4e3276e0c16a28b16021d82de4750abbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96f7ebd17fbd67c16e1f98836bf43c987dff25ab3789f89cdf92613e28f8c130"
    sha256 cellar: :any_skip_relocation, sonoma:        "237291edb4a04b1d7da8e088ac8bb5bd505c55a8f20b0e29a3ece28335a7dc60"
    sha256 cellar: :any_skip_relocation, ventura:       "9e736fdca6a45c803199f8b2d909f2fbc7e0cd2fa9d882de84824acec074473e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fc56b282b2b6607ed02c080c7cd3f38d91be3c5831b79ca5caa4013762a5844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81231bcd1f7ccb1fe34355ee8ad53449e0555936d00befeed55dbf42001119d3"
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