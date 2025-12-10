class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "e7e7574409bc466d816c20e9cbcc476ed9d78ba923fb54be5e91cc5fccb12a55"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51e5d5ef07c6ddb7dd814bc019378da4e8c414f0b113cbe44c1ed6358b09a582"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a19d96197d5376e7484b0af476a26c8276a4ac1672038bcdfc1da941b40524bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23d9c1484e36cece4736d8183c63229ad5268df3416fbb06681326fec86d200d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f51c3cbabccbaa5bc62953dbd453ff9d118c29be2d14116b249d48a0b6e7f983"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c1e33c49c57c98a730194924cc7f939563aa3ac0e7db3db516cee688b0e9a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ed17d242e324e77a05585cd33adfaebf77bfe3e4aea537b8104408552f205e"
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