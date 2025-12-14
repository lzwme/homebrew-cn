class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "e7e7574409bc466d816c20e9cbcc476ed9d78ba923fb54be5e91cc5fccb12a55"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c536fa6b02a571d98888ccc742094b50312d85558a7d32db4f728a0a411eb959"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56afe9019a057ef3421006d1cc85dcdf6d653d52a66fcfbd2a7f5a06b86d7be5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6a206b3e33f23d4c58c997de230d78c0d089d9372d3397bf39ddca661f0d893"
    sha256 cellar: :any_skip_relocation, sonoma:        "5eda33ab421fc19aabe7ae977fccb8eec8b1be33bf5f8522926351db578dfc3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c14245d3b6dfdc0851f1761e78e37d43f5810942ba38c8282af511f357cc693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ac3ccaa882b5258b2846e5be9876dc704aa3a38649fca7d50b463616a86321"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloud-sql-proxy", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end