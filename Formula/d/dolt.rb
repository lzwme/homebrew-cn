class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "4825bcbf6d4b62fcce5285a8f95bc60043583fac8a2e048e22f1e82d299ee37a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1a39b9d90e27fe352090f36a47403201838a72bab91428a6274155b58a7669d4"
    sha256 cellar: :any, arm64_sequoia: "a0aced06244951b4b0cabf4ae841b2b05d7d6347867213f79d072070f8e3a69a"
    sha256 cellar: :any, arm64_sonoma:  "49b2d9a5d0ce444a662b0d876b99fd86d439cb844676621e4f37c2220e080101"
    sha256 cellar: :any, sonoma:        "49eefdf7abb16a7aadf1e2c2a23d8cbb00bc48b5e6f99cd0459477fddea74aae"
    sha256 cellar: :any, arm64_linux:   "f97b4102f4c31b3c1569e3c2b15174c3aefc26b8ce8e21a58f901910f3f15989"
    sha256 cellar: :any, x86_64_linux:  "c2f13b6460eeb501872d6b84879259978f5047081176881011d0062be8eb40cf"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

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