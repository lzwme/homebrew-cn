class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://ghproxy.com/https://github.com/rancher/rke/archive/refs/tags/v1.4.11.tar.gz"
  sha256 "c04182cf0df6ae74cb3db6163f694f427fdb92a0f3621341716f107445860047"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ed15260735b0c4a5c28dd70b9151348e39d32edeab16d50f16060800cf60a20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94dd8255d762a363825c520702c9c636fcd7573ff239c5f890076e27debcc6ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6497071313589f058f4a122d1729ee30701269b962a8335573642995686430c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f90df0f087eca86598cdbc15c90e857985bb540b7cc0767385cc6e2a7787d38d"
    sha256 cellar: :any_skip_relocation, ventura:        "186dc027eb427f7dd65a6b70321289f39df23c6b6c941dac4f830b2f993b74c5"
    sha256 cellar: :any_skip_relocation, monterey:       "4d06f9a9e449264825a8d7f0957690104ea5aa9b844cd3ecc23e6dc76f349557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "448bc9d8aed72fe05233cef68c38b855bd5b7bc7aa3033e748014720355975a8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end