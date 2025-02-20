class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https:rke.docs.rancher.com"
  url "https:github.comrancherrkearchiverefstagsv1.7.3.tar.gz"
  sha256 "69562c4803e2f303dbb16168571f7a31d63c1b8561087fb70b95fe032d826a86"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b5f3b445524deeeace1fa383e86b685c8df9de3ed65316a71d0f2872f4a948a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e47df131aa8f64070dc8167717b72aa4be2917c8a8c2b929f4d47cd495c2401a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0de0708180ac753b9bb96e350a24d640e978ac750cdb7e4ccde4faa3e06f550e"
    sha256 cellar: :any_skip_relocation, sonoma:        "59fba1c4f7a020bd039e7553e9435cdd8bc608feb8f7a79ef2d3944e5ac3ea29"
    sha256 cellar: :any_skip_relocation, ventura:       "42fa68f84364bdcad06165d3613e0d5c97a581eacf2399f185976be0da30fb0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a2fcccdc8f67b34a67113fdca803478faf55c092e3e542028a348e14e2ada35"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin"rke", "config", "-e"
    assert_path_exists testpath"cluster.yml"
  end
end