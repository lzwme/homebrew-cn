class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.82.1.tar.gz"
  sha256 "76af758e3e679f41a7034e1187bbfde0d2e385cc2d403f81eaf3936a389af9cb"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f5613e3e3821900628ab6eb9cf8220f04389ef15be6ea44b651af58c517b868"
    sha256 cellar: :any,                 arm64_sequoia: "b78951d9ae6cc6d7bc1b594aaeecc8aeb860746e8af35f9ed0dcb43c3d420a33"
    sha256 cellar: :any,                 arm64_sonoma:  "ca010d7b7c99a89dc92c085062ac3a52a48e4bf035215296dd24782d57e676a0"
    sha256 cellar: :any,                 sonoma:        "8605d2c0c9c046aaaeb86c831b4d64ac7e08e165264b4d4d884df69b3b232e42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "501a1dca8be4b42edb85b56777d11c424d8aad68570defb20fb69a313abdabb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "291f6089d8b80b3101d6c527c7c865aab5f3cab7d3eb5f9c8717dcdf3f1ed75c"
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