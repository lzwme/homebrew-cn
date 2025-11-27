class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.78.4.tar.gz"
  sha256 "3c260771489f9de35d59a8f6fd9851d514b9509f811573c2c5a718bd05ca8712"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9f445ef6c1b847fe18ec5a83aee8556e8c81fef1d08be6a7fb242d910360519"
    sha256 cellar: :any,                 arm64_sequoia: "ead34addc9a6e85c63ffb59450813394bb0fd1f520130af8316b577d4a92d2bf"
    sha256 cellar: :any,                 arm64_sonoma:  "b3ae09fb4570fb4e145c25e02804a7c5cbcf5ee130134426bc49281c3e225100"
    sha256 cellar: :any,                 sonoma:        "c3a16bd3787ce5897ba783678e8ec6bf7b09a15d8bbdc7cebcc6771ea1435cdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b690e4cabd7d90eb21dec2da26ac928b3af6defbb1a4bd952c27a358260a4854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10625895ba21a7715622fcd03c182606e4afb37f3b59dd8fe8f92a38f3f0b585"
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