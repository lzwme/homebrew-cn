class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https:rke.docs.rancher.com"
  url "https:github.comrancherrkearchiverefstagsv1.5.3.tar.gz"
  sha256 "7afe775227219fdfa8a8fe3dad73c1dcd30b18563ce2fa04e5bcd8d7d9f503f2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8082fbb5e464c3fccad2ab0ac779dd4432f9f2ead4e5c3774818a5fb6660001"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47cd87372fb3ab36e88916e3f40bc9a93aa640891282d1193b3c510c02d96ce8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ab33cdc69c27b38d716e2b649c6b21a09eb9d721c90cee62622b660822e07c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "708399e7e1b8bda397486125e96f73deb429e3ee034c8dad3d0ddd2e80a2c515"
    sha256 cellar: :any_skip_relocation, ventura:        "854b9a8568975b23a1c31bac2a6521d60015ec13088dc3a6d1e7cf8b334df56e"
    sha256 cellar: :any_skip_relocation, monterey:       "d04f80e299d67709512128ef9cb068b5eb76753ad9dcdcb31c170a718280e011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b2e0a28f1037f4a745569fe03c2aed613dfd527010782554d1bb32eab469aaf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin"rke", "config", "-e"
    assert_predicate testpath"cluster.yml", :exist?
  end
end