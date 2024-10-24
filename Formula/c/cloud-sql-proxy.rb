class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https:github.comGoogleCloudPlatformcloud-sql-proxy"
  url "https:github.comGoogleCloudPlatformcloud-sql-proxyarchiverefstagsv2.14.0.tar.gz"
  sha256 "6e70f740d97ec5362f86b1e67a124524d84ea96ef942da00eb72813e8a3ed5d1"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformcloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d595a8116bd7d4e23ced223d6c855cc63ebbfd7919e137852ef2bb17d04a208"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d595a8116bd7d4e23ced223d6c855cc63ebbfd7919e137852ef2bb17d04a208"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d595a8116bd7d4e23ced223d6c855cc63ebbfd7919e137852ef2bb17d04a208"
    sha256 cellar: :any_skip_relocation, sonoma:        "c02ec89449183e593641cc31905051c32111920fabdcca3585a13e2406956a44"
    sha256 cellar: :any_skip_relocation, ventura:       "c02ec89449183e593641cc31905051c32111920fabdcca3585a13e2406956a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dad6d3f3e52104da80f5395a8621fdd2435641f975c2efece2c27ccc419f9b9"
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