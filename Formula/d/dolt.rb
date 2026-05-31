class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "a4205e795054ba9a3bacc895a2c592cc4f3da704e448137a82bec5c269df98cf"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "04794375921ea3d6699c30787fc283d24edd91e74b9c7c6223b7a631787ce073"
    sha256 cellar: :any, arm64_sequoia: "81776b096125ae39dad6b4a33ddd5bbf308020c4c3a048abb1853d6f65a3901c"
    sha256 cellar: :any, arm64_sonoma:  "53f49d1caa374feb0aa8e7c8fd530fd0adda11f0b5f49daba7b8afeaa22b3ea7"
    sha256 cellar: :any, sonoma:        "6c570ad02f74f9ec145664dd3fc702262c050827394f24aa3ac0b8df0fd794b7"
    sha256 cellar: :any, arm64_linux:   "9ce53fa186b39d54ef42a57cd5b973a8e48901e89166e7b0aa6d36fd49d6b236"
    sha256 cellar: :any, x86_64_linux:  "1eb4e76a61cb2d26183ae9185366cf843ceb024b6f663d3f2dbaebd10edb4d9d"
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