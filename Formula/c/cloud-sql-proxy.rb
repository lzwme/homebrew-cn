class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https:github.comGoogleCloudPlatformcloud-sql-proxy"
  url "https:github.comGoogleCloudPlatformcloud-sql-proxyarchiverefstagsv2.11.2.tar.gz"
  sha256 "efe51ed84c4d0b803ad9844c03fac28bfbf91fe72293f6182529c331f34ed474"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformcloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "549c6f6dba0c94b09e72873cbacf709bb9093337b03cc04d7f145a0c22641a27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1040f1b1def7abd642e2468ebfecacc7f2793ff77ce27c8e431d4f0e53c40ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3466aae7ac249abec30bb9cd10f0dad32dec76da86775397fd006ee7eef41f97"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4665b9392d699236757eb3ebd97cfa80cff4b2f1f2022248a68d957de70a5e9"
    sha256 cellar: :any_skip_relocation, ventura:        "d3caf16ae3a4b28da072be6ac933113e692554563fbba5a9a197f2225a1fcaff"
    sha256 cellar: :any_skip_relocation, monterey:       "acd22903a59aac9361045891540cb81e9e8ad17e88f9a50f5abbd48f177bf21a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "189860fb3affc5912c68faca6098f38855540f9348feabf81521daed88dbd39d"
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