class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.58.2.tar.gz"
  sha256 "a88dae813d41e7834198959eb53d5fd2681dfad48b6b3bf4968d7fe53585fb5d"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f1c2a8121063639d300c4ecea36e30568f2e863d413cdc5394ba2c2ff6de7c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "553966a7b27444b663a18777058d4b7d611092f9fd55d63d4f4a632d87e10cf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c937939c9a122997ff15582480f054bc5e6050e499826b8fb8c86066f2b11b7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "64fec215d4a3ac3bdfc4c03c607ff76e3ce9b4621d3cd286531df207a8f50550"
    sha256 cellar: :any_skip_relocation, ventura:       "c0183d0751be79e7154dd60d75092a74fafef769390f757721cda42c1a27be11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "991c622f36e1d6e0b896474c46f47bcaf087d0597eb2010f1933278ce9737e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73aeb20738af2c7e99b03a48d60010ee9f9dab506714db9777e6c51905549d46"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
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