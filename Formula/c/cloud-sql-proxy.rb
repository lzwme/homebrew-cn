class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https:github.comGoogleCloudPlatformcloud-sql-proxy"
  url "https:github.comGoogleCloudPlatformcloud-sql-proxyarchiverefstagsv2.17.0.tar.gz"
  sha256 "44a3c9d86af3614c985d003702ba02b03141ae388c5e3abb6130e1a35402721a"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformcloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdcb03e02c44bca2105c07da24a698bcb8d70fcb0be32ca9e3eae266a58c8ded"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdcb03e02c44bca2105c07da24a698bcb8d70fcb0be32ca9e3eae266a58c8ded"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdcb03e02c44bca2105c07da24a698bcb8d70fcb0be32ca9e3eae266a58c8ded"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6c3eb020a3f89b17d3681db227452941e726a7bae458f910d099d577e683dca"
    sha256 cellar: :any_skip_relocation, ventura:       "b6c3eb020a3f89b17d3681db227452941e726a7bae458f910d099d577e683dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b71271fa80318347b23b969e34e178914a3142e603873e4a0505b5395fa512af"
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