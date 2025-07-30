class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://ghfast.top/https://github.com/rancher/rke/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "483f857ee8369bf2063653131ee208f4f4ba397a14e3fa9c6073cdb6322fd16a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b56a92b0177f3227064322a0f3dc8d3baf7cc6888849a4d2102d98e800ea5fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a43a76eb259e76056d134896b861289d5e2cc39ddbcd62196de3c9243b7c339"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78ba3f272a899b7d1ed3c15e57d005451effccda1cda217adc1671c8071a1ff8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ef8e9135eef60b8d41e5824053ff149d9286eac7115ed8a9bea0179c75a4b39"
    sha256 cellar: :any_skip_relocation, ventura:       "9b7bf33818ac5d5678f220b1453c75004d46602619f994427406324cb717fe5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01306371e2662962baebd97edc5cadbd38884c76d588e1de22cdf876e8ff5f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff4203d4628a97eff13c05dc24a9623786cedd2318e077ccbfa5d3e15f02833d"
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