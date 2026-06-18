class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.1.8.tar.gz"
  sha256 "7e0b1668427c53ce568d32ae274c4a38a027c2ddd6b49332a3fef69b8d83b75d"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bc77568b1875a0eb4bafe93c913e7cc42a20175347ac1a423fdb143c35d1f085"
    sha256 cellar: :any, arm64_sequoia: "4f399753a8341f46ebb58ebc1d09bd47fcdfd33028d24a4347eb1a3df1108e6c"
    sha256 cellar: :any, arm64_sonoma:  "94527733b1d23c2e81e84639b48215b53d5a594f6ea57f5a61caec94f3794edd"
    sha256 cellar: :any, sonoma:        "feab76c81c26725006a8dbebaacf5e7acae4782776f90f14172529e904b7c15a"
    sha256 cellar: :any, arm64_linux:   "6a8761876a829c6afd2b34a48c1837b58c9cabf3d1b65fb8ac394966f79b6349"
    sha256 cellar: :any, x86_64_linux:  "94d0fc3e8dfe8887d3ec51996e08ad90cfa97bb3413e182beca72c812a11acd2"
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