class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "87ab6db9a087e6a7e80d3f7a79e2a3df48a84e566399b3250eb7ab0a0f052b27"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5384009f8fe055e0512f7a3e1346ac3a571d1e484d2da9f8c8bb6214ddca70a0"
    sha256 cellar: :any, arm64_sequoia: "a3538b81d75e23822ab26e8522debb71729bde96d055c06119f877881933fcd3"
    sha256 cellar: :any, arm64_sonoma:  "5d2f5bca2b11330b4150296ce5e5ce427bc7325c2845219d4d7b4920bc58ff5a"
    sha256 cellar: :any, sonoma:        "37781a8c7316b3cc13e2143e9fbb8d4dc439fe3826815e2672d41b5199d97e88"
    sha256 cellar: :any, arm64_linux:   "455ce3a894c7c966b5914212f38349c8f436a59b22a7de821be1ada3a9065d34"
    sha256 cellar: :any, x86_64_linux:  "875874aef2b7bfe4a820c7c1035c99c385af69871749f1a8f64e1f7e1e7a1389"
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