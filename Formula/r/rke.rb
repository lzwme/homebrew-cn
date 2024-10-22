class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https:rke.docs.rancher.com"
  url "https:github.comrancherrkearchiverefstagsv1.6.3.tar.gz"
  sha256 "7d51c06ff186a8004b5aabb69263bb35763b8ebc5537db8c7d1c7d2d35f0ac32"
  license "Apache-2.0"

  # It's necessary to check releases instead of tags here (to avoid upstream
  # tag issues) but we can't use the `GithubLatest` strategy because upstream
  # creates releases for more than one minor version (i.e., the "latest" release
  # isn't the newest version at times).
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a2c009c829cf98ded568c1ab7556285e6edb27064077fd4c79b5289b16b124a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4527b0479a53da1328d49c1949e12eaa88024abfe31bcd160f5af83ec2c17b23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e587bfcf636f8fd18af7b0e7ba5a0493f8ec8fc7893a91dd0b36a8765753c184"
    sha256 cellar: :any_skip_relocation, sonoma:        "de0a34fe1579da7ae522e2a38be6d274430215120fdad08b6e9814d11fbfed31"
    sha256 cellar: :any_skip_relocation, ventura:       "4b7bd398247cdf678f5e74e71ce339c39050c8ca4780af2eb77d23bcb72b7a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0c7b12a8fe911ce245f68687e66f11bdbe14b3d4b8ff234b73347e85a56e595"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin"rke", "config", "-e"
    assert_predicate testpath"cluster.yml", :exist?
  end
end