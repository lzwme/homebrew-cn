class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.81.10.tar.gz"
  sha256 "44eb1c8b8757cb296541bc0ccb522b29c454da351230bbfd66ee1c6fa27f8a19"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac7ec16aaaf1e27fa11dc93d4fcbe259f37c8635799c61b0b67118eba8d8521f"
    sha256 cellar: :any,                 arm64_sequoia: "0c47acbb64a0b60101cda6dbbf2a2d0094e90685441648eed24d9213257156a8"
    sha256 cellar: :any,                 arm64_sonoma:  "1b28af32a4f50a28b5f097749ce1d97d212022d84f3ad26efc299b8fbd0f7751"
    sha256 cellar: :any,                 sonoma:        "d1e92747fc1a37745e4cf49eb4aed1d5adb4dc09cab9b264d9c6fcd96d899f94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c8b62af89a4eb181096b018f7b683186f5ba00c0450d8592b02e365cf47de63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5a0fa7b409da59fc747f51db3c2326238e5e8ec2ced1725f424699690602e9"
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