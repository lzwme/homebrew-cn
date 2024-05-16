class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https:github.comGoogleCloudPlatformcloud-sql-proxy"
  url "https:github.comGoogleCloudPlatformcloud-sql-proxyarchiverefstagsv2.11.1.tar.gz"
  sha256 "50ac079d38cffbcc6b5bc58a5b6b7bf01434aee859d6cfe4fa6b15ce0de32ba6"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformcloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c870cb7c0f0f660d44f6bd16be3fe2a5b8b1292fadd791c466f68d27379c905f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72a80eb8e35e642e5ef014cb1df44b2b2a3c6c796a0c8f53eef01d28a18577a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1428541fe1abbfba76d61ca543d66ba264fa84778ae1d168408f9124d6274048"
    sha256 cellar: :any_skip_relocation, sonoma:         "025e39dc89a76953d33dcc3d42a23028cbc3cd3f5b2ca1853024afbe3d81ac06"
    sha256 cellar: :any_skip_relocation, ventura:        "3cc9f9e7cce08a3c38b613d0804bdd537e27c1c1579b71403a0c0a2c9149ddef"
    sha256 cellar: :any_skip_relocation, monterey:       "2128818af7cb1d9f04c43f2f4f0eb0aed26e30d8c32d0786c2312b6e2dc06cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2db42089b7985a0f6fb1cf36a8b37adc78e820a275c9904d753d8b2d12d0800"
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