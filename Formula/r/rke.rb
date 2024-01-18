class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https:rke.docs.rancher.com"
  url "https:github.comrancherrkearchiverefstagsv1.5.2.tar.gz"
  sha256 "72b87b4c66c92319cc6bf4c33e114b8bc8b8efa8de347e74bbd569a8c664e888"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e31a3dc5033e13c75cb1fe87922719662d9a3a589de4714eee45f592c7a8ae70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df6073bc43e01ad4e5390974ed883bd1926383883471467cdabe1bea6633f950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "265b1febacbfd2e1899646a841567332e37e1d9965a0741791cb9f2742f098a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5dfea7aebec8e39d0c030c423b0bef8bc7e7f955edc1fb2e85ee4796a6be5642"
    sha256 cellar: :any_skip_relocation, ventura:        "9919d5699708e46a8d944e6c8860bce4a03397a42da8c6b2c1803fb74643492c"
    sha256 cellar: :any_skip_relocation, monterey:       "1b8ef8ccacfc914e59c3d6fbfdb70c73d25489f90777665d1000131f0da02b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7dc9f4c411dd35cac36384a50ad48e1e6b79a070787d14619b04b0944c09bb1"
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