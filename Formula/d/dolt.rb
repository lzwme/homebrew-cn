class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.81.3.tar.gz"
  sha256 "59b43b733e8dc397d01b40cc26d0395eb68591a9d97c80430c932803fd1bd740"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f8662a2d494cfc7da94903431937c98f4506fa13c5c65eec87600d49b93c439"
    sha256 cellar: :any,                 arm64_sequoia: "0bf1696f99bb9bfcd051243c30eb1dd68443361432a46680a81082541bf2508e"
    sha256 cellar: :any,                 arm64_sonoma:  "1a4baa8f9d7073c085df4f1c2b0298ddfeec73a35d42a5a76a1b0b11739c28b9"
    sha256 cellar: :any,                 sonoma:        "982102e92f0292d137c30cbf04ed2a82238fd5a52cd0a0a1c790e8f1f4cb41b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be3692aa56cfa5025bf7c6ef391a9e79d7ad8e9892d9cd787537d9953b358593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1727b201c9944c0784cf154dd8417a5ac7a4e3a8165ef98e6b9dfc5b07b2bf64"
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