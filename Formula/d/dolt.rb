class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.86.4.tar.gz"
  sha256 "07a87a3fdd9dac9469ffae55224a72f7b51f62a122f1331475d09b3b06a7f7a3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c53b29f680b8a3985f4108164147b22e6575eb4a624a6cf8a84ed1930cdf915"
    sha256 cellar: :any,                 arm64_sequoia: "b91487571bcc7265b3ce067b2e0d421d83df940b43ce5b427287a798cb9ba79c"
    sha256 cellar: :any,                 arm64_sonoma:  "1311de7aa7c558a4a864b0759045fa90742c41828e67d458a62833570594ec7a"
    sha256 cellar: :any,                 sonoma:        "c39238aaffae01066799f3296e29c13288d0e368ed46cd6ce875e88081f27bae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a455a84ef1a5a3bedd6e2679265a540ce642076dc6c107e0012edacf50dbbfbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed2ddebf0592e6732945888209bda2f58f80d202d7cbc7ac28fb85d2a0f1b759"
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