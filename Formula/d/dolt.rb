class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "28424819aa02e249ca8a35f81bc550c736971538550ad8cd9bf67ddd73fa29c7"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "159c0f07964c62bbd8ed9126af86182929973dfe68b6ce1006bfba3ea8360553"
    sha256 cellar: :any, arm64_sequoia: "5ba813a385cc1bea111638b6951c7876f394c93bc40fb25881dd236f6e3fbf78"
    sha256 cellar: :any, arm64_sonoma:  "43b08bcb4c8dc4fdc936b05470cf561c58bcfd9edbeaf3172202886cce962d84"
    sha256 cellar: :any, sonoma:        "d59e51a8cc7a7db1e31ccff14720c37f52e5e140ae6ca6f34d4c84f9ce35dd0c"
    sha256 cellar: :any, arm64_linux:   "c3bcbb361ab71bf48bec1dd2eb29a9676d60c194d3be772e667d45d7b2e53b80"
    sha256 cellar: :any, x86_64_linux:  "33261482fdfedd1958ed65b07e679088ec62de83c93dc9b14c68df327a3bd392"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

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