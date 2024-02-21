class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https:github.comGoogleCloudPlatformcloud-sql-proxy"
  url "https:github.comGoogleCloudPlatformcloud-sql-proxyarchiverefstagsv2.9.0.tar.gz"
  sha256 "f1623f1a8ac4798ac95f4908bd655265b947aad3101b4d68750527f375bf42a1"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformcloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d54a6e5116caf24d7e26f7c9ade6482deaa17c713cf414cc9d7b5b260a8cb27d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27aabc567a9c856a28f3d8586ca74c2eab9998e0679dd95b86bd0862df4a0094"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4dd813158733c8362c3111dac3b63a6e7a951a001b299878438773d1aeda4ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6072cae212e0c2bb4bbafac7fc0aecf578ecee85796b6a80fb7cacf7a1b1e32"
    sha256 cellar: :any_skip_relocation, ventura:        "f9af46a3eb133c802a8dcb2706fd536e9c8a32dd56234242ab04fe1c5a5bc717"
    sha256 cellar: :any_skip_relocation, monterey:       "ad85b6d3064fa7b16e6024fd03ac254c53a63f4ef4a3813d742bc6254741b3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2a66bc31ed0f2e1c017ef927fbe7a7c54a7d81860d88a35977f3df2076426c8"
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