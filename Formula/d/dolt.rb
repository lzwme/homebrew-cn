class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.81.9.tar.gz"
  sha256 "2326a0b81daca575a8d6629bb79ee4ee778e3ec057019677560e3c577254344a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a6058e78511f7b83a82ececa0c30237eefd81c07dd67a37069d6068333c1a3c"
    sha256 cellar: :any,                 arm64_sequoia: "3a56f4a22c320cc22c2646343b25492458ef4b1d4e48ae1527198f9f20fb87ea"
    sha256 cellar: :any,                 arm64_sonoma:  "e3a83595bffd877453d85e513a135fbc0fbf1cd5fb3459cd2d12d26bd5d228dd"
    sha256 cellar: :any,                 sonoma:        "352a59f3ee1aa63bb8d125a7a3a15dcc1122e15554912a818ffa48d22a83d913"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36d30ec34f0e4fa419df3bdec4711142dcf27e7f18e3a0773539e000789ad2ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce135df6fb9c06c21587a970c57194ebbdee63036ada69ca65cd97b25bd5e200"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
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