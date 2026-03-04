class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.83.1.tar.gz"
  sha256 "db3e71c38a17a857a61825f67cd7c14e481af558c20d43786c431a9ded6216c6"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "176b4de3c7df6f9bba42dc59d4570080e700980d7e2294406b262fa50d59eddf"
    sha256 cellar: :any,                 arm64_sequoia: "eaf70f43bd3685876dfb35573eaa337177e551822457fa0747583b7ba61cafaf"
    sha256 cellar: :any,                 arm64_sonoma:  "62284ee04410f2cd90ffc767c03d16efa4bd99966379c997b726128fe10adcf0"
    sha256 cellar: :any,                 sonoma:        "06909ac893c112fc13ceed5b6e7015f3a532ae3581aa63abebcf4d4ed5e889e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff0a938f30dab7538f64ebed9aa43f505cbedd05b78945f01724227999062b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad593ecd7e947f29a0f5055630eeed99a55b3115f3f29bc0f3d942d76a093d6b"
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