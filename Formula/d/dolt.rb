class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.78.8.tar.gz"
  sha256 "b545083aaa8dc0dbd1fe94ae321a4bb9706fa26e84c8b37b2339743957ac7d0f"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "738876ee9045e881a99363d9675f8b9423de3f2d29636d00af8a622b93653e97"
    sha256 cellar: :any,                 arm64_sequoia: "9c825e67e8ba06a2cb36ecdf5653b140bf0453ae135d90438b9cb9899f168bf2"
    sha256 cellar: :any,                 arm64_sonoma:  "0d01c1b766dfc6d63cfaa6659b4e05ecedd0cf4e1d5416268fddfeb5ab6d3d38"
    sha256 cellar: :any,                 sonoma:        "63bf2059ed3dda1d83b2e9dbc1f4b90dcd2041ed639007152e53d21790b31cbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dd3a3c4596ebc45f704a14c59aabcf3fbe5cf2dd25cd391b6d178bc0e6cef25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2deb3dd4a044a3009fc3ababf5f99e1fb3c0d4a737094375d6baed1767bf390b"
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