class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "3ea718535f03b38ff38ae05557f86d2f378dc07933f5d41a8c36bcd8d46521a6"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "23e4b5a3dcd782e3142e6b371afed027bdcbe8ea3d30a9d4aeb3873412838496"
    sha256 cellar: :any, arm64_sequoia: "d4eb612f1c3bf3817cecbaa0d8e62c857e51c14dc1005a8c5527f2ef2a53cbc0"
    sha256 cellar: :any, arm64_sonoma:  "add0f626c4e0d0dad8a37af313204a802dac2e0642063d9a67ec8762a43c59b8"
    sha256 cellar: :any, sonoma:        "9ff9353dbf7488117a82f6911b26a5648f8fe3a33fc145ea897f6387183078e6"
    sha256 cellar: :any, arm64_linux:   "3f7d2a412acb7196d00ac1f6fd9f2e8d0c39d1bc7f80ab4a8dae873eb9707529"
    sha256 cellar: :any, x86_64_linux:  "88b647cdc690c7535c001426051c6ef4e7b56d8b58564a19bac7ffca9b1e3f09"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args, "./cmd/dolt"

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