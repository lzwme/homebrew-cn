class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https:github.comGoogleCloudPlatformcloud-sql-proxy"
  url "https:github.comGoogleCloudPlatformcloud-sql-proxyarchiverefstagsv2.15.1.tar.gz"
  sha256 "fc549384f888a23f3c4a26aae4a8381fbe973a65ae9273afda403f0553bd3b13"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformcloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af06011f26010c30a4a945ef460c6e508a1d8f08f8e028d83524eab78ce7c3dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af06011f26010c30a4a945ef460c6e508a1d8f08f8e028d83524eab78ce7c3dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af06011f26010c30a4a945ef460c6e508a1d8f08f8e028d83524eab78ce7c3dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e816d797bcdb365224188a4da6cbffd14ea15c87e46aa1e89cb3234bd578cfc"
    sha256 cellar: :any_skip_relocation, ventura:       "2e816d797bcdb365224188a4da6cbffd14ea15c87e46aa1e89cb3234bd578cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03805457754f5bd50eb0ab70e08d1b638fda203ce26b3e25437792178f04dc36"
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