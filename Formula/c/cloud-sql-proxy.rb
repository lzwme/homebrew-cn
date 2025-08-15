class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "5600085ac4a62c32da04e4ad425bf6d311f9aa0d65fbecaa8dde6bfd3abe8b8e"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f66b57430fd40aa819c2dd9506c4f5b3a2061dce6eba6f3ea845918f755a6dbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f95bee923876eda4296e999d6bdbc008f88ce3d1a9f98dd24a846690aa1bc3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8cd981748f8e195d6761a5f2b1765b2f35c9e0fce6426d2d2fd7432057fd698"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c1cd9f20be64fefc0676cea93d728aa2fd399e7512b092be68480c57b1f2294"
    sha256 cellar: :any_skip_relocation, ventura:       "4f4ae1f5376510b2572d90f5ffd0d15a26e66f981dbc53ba30711a20445ece22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6010d102cb86897884de54a3f83e6c82ad55937dafc223e1634275926ca7376"
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