class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.83.0.tar.gz"
  sha256 "c2e9f35e7b6b2aefc0976c6041b8126841e4a35ad112de4bcb0060bbdc0d1d3b"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d1f29531dfa1e6e4c2e0c48ba946b26d1a821c4371e32a8f2364360ce1ab23b"
    sha256 cellar: :any,                 arm64_sequoia: "67fd1239f76d64dc9eceade9fe6b7922986215c694fecafd44d0218275d3fd83"
    sha256 cellar: :any,                 arm64_sonoma:  "211317fb9740240e2dc4fd6987f43e841f4c5eb68ff2b6951ca9b0e624987592"
    sha256 cellar: :any,                 sonoma:        "b7e5f48f515e740cf5933862dd91d32f388b541009bec523a66bfcf0db6bc596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44d22ac906af0288c4f13e08fc17dbb67ff5e9f1121d33e6d56095c3a01021d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d002f9b90919155c9785f80d0166eb695dc84b97617361233c5cec3f05f79db9"
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