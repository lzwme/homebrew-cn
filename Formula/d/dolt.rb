class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "ea5fd26263913647bff49fed44e1404df43229d90e27f3e968a8628eda408340"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c27368e2fd4d12779db7f760889da5bfb71f1618df8afcf40d956875bd6d1a0d"
    sha256 cellar: :any, arm64_tahoe:       "2b217ff1fb8b78c4361885df2fcf03facb26bedc7223138411d5594c4cd05261"
    sha256 cellar: :any, arm64_sequoia:     "c2ce798ab9c759bd0f820dc942db29a396f45b801a420d97a002305fdf96bfaf"
    sha256 cellar: :any, arm64_linux:       "3e01f91f9a518a4fd2e5d3172b4fbeb81d80dfe987b316dc20b38821f3d5cc8d"
    sha256 cellar: :any, x86_64_linux:      "f0050c2c26913d9798197d9610ce0325d0504fbc7b01fcd2d6411a0699e56707"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "go"
  end

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