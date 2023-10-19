class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghproxy.com/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/v2.7.1.tar.gz"
  sha256 "de6bc89d1d514b9c7b34fb7fec6c582649b805b14f9fbfcd2dcba03a8d3b2182"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd1385db1e1d695fd616d50e8377abdb8edafb9d15dee28eaf0c4dba9a02462b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "390cec23136de7e2d2343603f40543ccb88c40037466db0a647f33df9b0776d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41109aab88beebf64a5b3075087543a2229169cbc29c9dc47488437efe04d02e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c6029f5c81fb4067d5628693c8147bfe7349fd50d08698d323de719619008cd"
    sha256 cellar: :any_skip_relocation, ventura:        "16f205af970cd12801b41c73906206cfa1dfd4951f987f200745087aaaa95188"
    sha256 cellar: :any_skip_relocation, monterey:       "a4e597028b4f8142ade476720a721f62c9890e9527021562126ade3b7ec16203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c55a97921f9c7b26869df0b8e2d2bf8c03951a17be4af3bc61bf15c0d1ced71"
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