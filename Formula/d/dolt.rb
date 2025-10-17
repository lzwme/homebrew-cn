class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.75.0.tar.gz"
  sha256 "93c7a7a553ae9658849aee10818370f85e77a8a57909bb371ef6c0c59dccbfda"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a11cd7a23c8117b0d19a260b1cf50a10222649435861840815da1fbb70a82c47"
    sha256 cellar: :any,                 arm64_sequoia: "a436059c32517329a226134bb747892a4c9b000ac0a821efecaa033f7e4d8dce"
    sha256 cellar: :any,                 arm64_sonoma:  "fa4c2d86836ddbe050441b2e8cefc1840f30c57a2801dc77028c1b3a02277b32"
    sha256 cellar: :any,                 sonoma:        "b3df8b3c23bc5164c78349152c5ddd2197aadf50c265989a3431bf6a5da233a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "663ee3068b655109f84e3e6773b7bdef45adca24a423f33706c0e14f77e04411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0344c67c2356295d78a98dde13b4338949c08717830060c97f31b34f929c73d0"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

  def install
    ENV["CGO_ENABLED"] = "1"

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