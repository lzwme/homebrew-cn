class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.88.0.tar.gz"
  sha256 "14d4a178594a9ddabe96f73e0ff4b087de62d32eb9d21069fd1c63ba4098028e"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93c4f124ce61d356a6bb2a4cf16abd627d07d9c4bdf3e3957e142104d91674ed"
    sha256 cellar: :any,                 arm64_sequoia: "679cadb0f68c98bd75506ba3989954efa666600a5c8c3ad7d82684db2e28ea2d"
    sha256 cellar: :any,                 arm64_sonoma:  "a174fba93bcfdb58b987269aa95c834e76b575bfc033168ba2db6fa75beb6995"
    sha256 cellar: :any,                 sonoma:        "e44e6a301734fe89a1942301771663e0561d92d9e2681295e0c15b2d961e1ae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5dc2fc858c97d7da997038869ff127b2c4ed476fdacab155542b68a21f2c47a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e872086a8dc3de2d1cd5569fdfe381227ec37d6a1b7e606d6fb6a9f638c16fa6"
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