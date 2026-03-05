class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://ghfast.top/https://github.com/rancher/rke/archive/refs/tags/v1.8.11.tar.gz"
  sha256 "09cd773030b9b9cc614c4331981aea9c275e6c51b939c83d872796b5960e1b0a"
  license "Apache-2.0"

  # It's necessary to check releases instead of tags here (to avoid upstream
  # tag issues) but we can't use the `GithubLatest` strategy because upstream
  # creates releases for more than one minor version (i.e., the "latest" release
  # isn't the newest version at times).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8204b96d2b412d62fc1f583f621c162214abe1fd774b59aa24e22d8c9ded53b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c854c5568650b7c5a69bb7b4cabf913cef8d96186a5cec928593fd0abe8446e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9e97ed5ae697fd5e846a26e3c6be54ffd55dd2555127d861d6ba38013b08b49"
    sha256 cellar: :any_skip_relocation, sonoma:        "9116a8610753206ddfbc415c3fd255ee40d35cd106dfe5d42363b56cdb7e824a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88442bb9d5411736ea0abe5ba1022e0b5610087f8429c3c3d37c0b5825da5e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a281ef15ca29f9cc17efb569761c5e408e8364954b31cd1dd38e571e9933aea"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"rke", "config", "-e"
    assert_path_exists testpath/"cluster.yml"
  end
end