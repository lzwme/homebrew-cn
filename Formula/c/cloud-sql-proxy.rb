class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https:github.comGoogleCloudPlatformcloud-sql-proxy"
  url "https:github.comGoogleCloudPlatformcloud-sql-proxyarchiverefstagsv2.14.1.tar.gz"
  sha256 "656e6cc8dc72ae2844e4ab3fa2e210c91a245133f1c42a8d94b10473fca1350d"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformcloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d434ffd248c11e77ef2bcd20bc6b4111a1b620400de178129ff7336546928451"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d434ffd248c11e77ef2bcd20bc6b4111a1b620400de178129ff7336546928451"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d434ffd248c11e77ef2bcd20bc6b4111a1b620400de178129ff7336546928451"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f538ba8a6d7d5998b5472bd667c6c96b20e05718648348367054494894092e6"
    sha256 cellar: :any_skip_relocation, ventura:       "7f538ba8a6d7d5998b5472bd667c6c96b20e05718648348367054494894092e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2b3f0ebd99dae4fe80bc712e83d0ece86ca35f2cf23ebf6b7fc509db683cfb2"
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