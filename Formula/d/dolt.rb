class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.1.9.tar.gz"
  sha256 "d36398de9046154469e492d224213d46ae2a89c4630d2318db581f483b16d60a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a829ba61437a1ca7534438d8cbb6dc170f0ee56798e480052751c9f42f889ed9"
    sha256 cellar: :any, arm64_sequoia: "52669a53e85d42fe9d029406a00d615ab1947ead44ebdb67508228816eaa6d8e"
    sha256 cellar: :any, arm64_sonoma:  "11db95444fe117cc350c9b278899e1db23a584d78d6cfa6fbe4d1efbe8940707"
    sha256 cellar: :any, sonoma:        "25baba6e6f3d184d60c368418a447bfa7ca57ff5b5c4875435a2c2c756d30f93"
    sha256 cellar: :any, arm64_linux:   "9fd5c381b880ede98f86557e73a5b182fb674b587505eb3cfacc38f2d5be105c"
    sha256 cellar: :any, x86_64_linux:  "4c16c49fd3b851b7d4fabb5ec44d9acd4115f3d6ec91c2fd51a26880b2cad095"
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