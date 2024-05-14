class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https:rke.docs.rancher.com"
  url "https:github.comrancherrkearchiverefstagsv1.5.9.tar.gz"
  sha256 "3e58da7bfb04f8b827b5ad864c9915af16f89c597339ca80844d226a0b25910a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51342816822dd913ab9c4809ac6abc8a4b8cb274c6c497469379540b015ae2f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbf52c044da06c5f580933c626231bbb9fbea5b02db806b12368f636e48922a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7469b6f9ffe60101f7e28e9002fef3873f452529bcf46a0841b660c8dea33fdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7400aec25b4b1e6ada68d4b3fbfed65e4edb27cb91b080cfa4ca513947d14e7d"
    sha256 cellar: :any_skip_relocation, ventura:        "173375eabf20674c094e12d575395f5c61e7a7816530395da25f028dbf695495"
    sha256 cellar: :any_skip_relocation, monterey:       "fb94bbcd93411b08b05330bc7e7680e2b888771749040345114cb900f4f69936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cb02017f9b7eac16ef919f2e27ca3509de39be09659a3fb4208a603598441bd"
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