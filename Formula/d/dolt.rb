class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.86.6.tar.gz"
  sha256 "a8b605e5a27f3d9fbbffca4d2175f04f83ddf81635c563edea853890283f70f5"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4fdfd183f5d87103b3d6516ca6de8575c5caf5211ad784af97627b9882d5e983"
    sha256 cellar: :any,                 arm64_sequoia: "76c0aa38763a6b037ce78c9b8733559417a489b7bf167e47baf8554cdb36e7d0"
    sha256 cellar: :any,                 arm64_sonoma:  "83735b6ecf5d1081b3c5c63e26b6b1b91ccb6c2eaa369f79b8bdea456b6db94f"
    sha256 cellar: :any,                 sonoma:        "83e92620ee906dd6640cb6819e31b8fb5cb75fe9949594c9ec7f5da456a40887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a636cc2f6a4284c03acb696ba5ba164274861d6de407a55bf9caf2d67e35ad5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d144e1617893b0b2c0709d3b9f972911630a7963c194ba5a254e04d6110d0fb"
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