class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghproxy.com/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "2b6e7ff2ee9efee764ff12d364112e37db6180cfa3f4b6fd0a8034e40afc88f0"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a6c392779ddeeb9b7f05e4cdc02099ada998c412d601a30cc06a6e0e5ffdb53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed15e2752db127fd8897c097db7e799cce2859fae0c08729ceaf339409652c21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64d47a89a6e5a1437cf04c7444246bf25d806735529a30d98b7f3d3b6bbcae4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce0b46bde366c14172715996864fd94af7ae97cf17b97e5259d55f46837dcf24"
    sha256 cellar: :any_skip_relocation, ventura:        "8a7464fe4cc09a74559914438e79a42ac036951e3956cf1232c398b72cee6a09"
    sha256 cellar: :any_skip_relocation, monterey:       "30ad5486c109c993cd700e43cde1d8d5bde173fb099fa09345b0e254b4f61ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ca33425707c61323169e6cc473cd939419494395023e0cde814aef8acdc52ac"
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