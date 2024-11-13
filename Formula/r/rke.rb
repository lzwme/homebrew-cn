class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https:rke.docs.rancher.com"
  url "https:github.comrancherrkearchiverefstagsv1.7.0.tar.gz"
  sha256 "23c6e009937401959c232abbc357d29232a59a31ff1a261a1a12b859b8dd7f51"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "551f96c952d03a4aec570d3c90e8affe339fa2b8d8e88b4c4ef598f381dc4962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "518282a4273da3f0dc507269597d6964528ce3b71e62fa8eced8b297c109c754"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e218e2fe79d1f3f40baddfc54c0cdeac312f68965f8596934420937264bea8a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "16d0d874255ad40f1d07231d932241d69f1c54e282b42a5a59e3189b5624360e"
    sha256 cellar: :any_skip_relocation, ventura:       "f5d6cb5ef6803bd32807bb6ba59d807ae4c0a050785e630314efcb66aa4279f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6a49d8f62dafbefb523963851f2f973abd2b006cf5922d4875797f22099bade"
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