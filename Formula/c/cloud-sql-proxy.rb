class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghproxy.com/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "665e8abc91a7496a784a2e6c723d676517072ebb22171beb5502135a3ceb1d9c"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40b32111bb84778218fe384a4453ce359c2523bd112eadc5a179b90f1a6fa34a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e6442ac8b2c75bfc453e7a7dbef6da6a68070a03a5e6991d7fb667547ef08d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc606138bf3e7a38b90b44d2115311e2bcd8e8a539e289603acf5c4d8a0214ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "57b36da8c567724baa797bceec983b431d1d185fe9d904585f8a29cc131c57e5"
    sha256 cellar: :any_skip_relocation, ventura:        "c64dd8890d12d98fe69eec7dbd1971d6525a2c91608f0e5a990fa22e8178df66"
    sha256 cellar: :any_skip_relocation, monterey:       "c14ec0392debb8055a8c3268c17546fc30e6801aa379af663bea40af39222949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54d9ebdee458a2250de73bf0a658051779028f084988c80cb83195eb746feb85"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end