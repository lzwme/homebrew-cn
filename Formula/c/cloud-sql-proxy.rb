class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https:github.comGoogleCloudPlatformcloud-sql-proxy"
  url "https:github.comGoogleCloudPlatformcloud-sql-proxyarchiverefstagsv2.14.2.tar.gz"
  sha256 "9700156c7fcfd9a8fa5730bf10277fbeb3b63a61b2595c03054a58f85c2b81ef"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformcloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62bbb45443ba44d27c2f6e605c09b9c8696d8f1d16d0d88bfb13917af6fee216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62bbb45443ba44d27c2f6e605c09b9c8696d8f1d16d0d88bfb13917af6fee216"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62bbb45443ba44d27c2f6e605c09b9c8696d8f1d16d0d88bfb13917af6fee216"
    sha256 cellar: :any_skip_relocation, sonoma:        "9576bb74a69597cd5978d2873a2aa9ef565f46285ea53df206ded79c300edeb4"
    sha256 cellar: :any_skip_relocation, ventura:       "9576bb74a69597cd5978d2873a2aa9ef565f46285ea53df206ded79c300edeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed04244f4fe31273177f6ced1278c20cf3a8daac7869662eebea4dcc21bd166f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}cloud-sql-proxy test 2>&1", 1)
  end
end