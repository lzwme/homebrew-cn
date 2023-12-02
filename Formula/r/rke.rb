class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://ghproxy.com/https://github.com/rancher/rke/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d1246003ee439d6e8416c073434dd4111745862063f6ecbf05b65ac0df266897"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc5a8af703283180a623bd7f3474c727a6511fe20b46152d385c064f9a18df09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ae7ee8f02081142fcac20325cbec3bace6dd844e28b12e8da14c59c259a9cea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f5344e9fb76505d55fc45e70a783e00242c36821aa00b7d118eb43be48f3f84"
    sha256 cellar: :any_skip_relocation, sonoma:         "8440573e85059df6d01441aec479aa769a6d2f839d9b40d55ff46165c47dc698"
    sha256 cellar: :any_skip_relocation, ventura:        "ba04019fbf2ad89e7b12cb67c254788c5b68e5f9de71858f6d9f7c44f15fea54"
    sha256 cellar: :any_skip_relocation, monterey:       "68f11cc2b1c408027e06c647078eaca38b16403d58f5f52fb574c294c184b480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6429f6b4c50fa94b2f325f7ea2d4b9cfdb1f9e0f0b0c6893d014b0dc294edbe1"
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