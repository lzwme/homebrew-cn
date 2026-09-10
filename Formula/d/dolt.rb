class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "25977946bd39aaa94c63c3c7f081905994273da4d506036744caaea9d531183f"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "38c1ee3aa60c75ae1cccdbaf33a00d9a271fa8214823ef206bd8980756e0109c"
    sha256 cellar: :any, arm64_sequoia: "4580a771303f4d919fd815f2c6762c757956faa493c508f34e5cfadd7c8bef6d"
    sha256 cellar: :any, arm64_sonoma:  "ffb925150d849a990488903af228810705d4e976d970c326615e1e27dddc0dad"
    sha256 cellar: :any, arm64_linux:   "132080dd40dfeb9a142a3e84f44aaf570a6dfa32ed232b51f369b0c6dc91d613"
    sha256 cellar: :any, x86_64_linux:  "932700b17f4daa652df6dc440c4f89473a8d177dc851140198ef36cc45d1e4a6"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args, "./cmd/dolt"

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