class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "432934d575303204c8f9d19e8c0ff76a56634bc5830660b26b30d10d119e1abb"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "95269412ea22c4d88fb2686851ab6eff8e9a5a86f525ab7b0f095f631c5ca9e8"
    sha256 cellar: :any, arm64_sequoia: "04ea6abc144320012d9ac5b034326a04138057fd6459dd7006b2d876fbf50ae8"
    sha256 cellar: :any, arm64_sonoma:  "ee686803959ea5670fb52f6f1cf949ccab2313097ea863688efabc7e9908d687"
    sha256 cellar: :any, sonoma:        "f10d109489f315c3a99ba4c9df01bec3b2a3ff8ea91412b20c56b3fb2756d677"
    sha256 cellar: :any, arm64_linux:   "457b4f39a9b0ef67e113e3f54706d931f2f6aa4e956943997c1be6ed197986a6"
    sha256 cellar: :any, x86_64_linux:  "9c0482ed1108456d60b25efc6d9513649a41949b3042f09e65172462a26766a3"
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