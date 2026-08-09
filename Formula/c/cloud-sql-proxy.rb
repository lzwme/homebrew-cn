class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "ce721deeb43fe20f5fefa34afe03b075824b61623f3c2f100ef96bc7a4272e25"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fcf88d3c5aeb9c60ada9b898faa5ba9f4dabcc41a29165db1b6a9bf59e16aee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23eddd132cde2df7167f6c7f99f949f0fa51149e4dff7f950eae4ad4d6caee28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26688d7e6131b31c414edc5dfb36641ecb0a929c55ebae0c7639e2f86aea094b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d99e6d0c61c4e461ba06aeda7adfe5ba7c308348a7286e4de3c703bdbe170c18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6711b563565157b53f145344e81f2f9f18320bc8dbb1da2b2c97b1216a77c7e"
    sha256 cellar: :any,                 x86_64_linux:  "da0d9e9663e2abe722d039967097c0771c5652ed67d324a1ff9c3eaf6d8730cb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"cloud-sql-proxy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end