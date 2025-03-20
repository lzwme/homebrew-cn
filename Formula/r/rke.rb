class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https:rke.docs.rancher.com"
  url "https:github.comrancherrkearchiverefstagsv1.8.0.tar.gz"
  sha256 "c289a7e6b4550c82a4520beb7bfa5a2f81a4d3a3ba6706e3ed42a0a2352cc318"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4d3c4c15316bb1026812fbb846e3e712e9dd66ddfdf125f98c8186e553ea726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc18587e3535739bb795f3e64a2196e22bcf6c105fde9af339f983ef613ae321"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59a872fb498be4b314677add346222790493b027ab1bc1ca247268c5beae940f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fda28cd7449af709423be97d7ad7ff426a0faf53740accfb384ee12b5a68c6b0"
    sha256 cellar: :any_skip_relocation, ventura:       "e7854e04821724e6ee363dfb48fd124a0bc69dfc41081a484f76442a4137a1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f04285eddcd18e73a701692b361cfa566135e5cc297abf922761f0257e6a114"
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