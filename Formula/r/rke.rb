class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https:rke.docs.rancher.com"
  url "https:github.comrancherrkearchiverefstagsv1.6.0.tar.gz"
  sha256 "20a806265a1043ea8ddb5004a1e5fedb9fed6c46457b334b8c69f1f9e2211d7a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e56fda716709918225398481591ad3b9a4c152033a3a7ec61d4a94e7d26126f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02f5043d9b6f3d6ed10f33325dc21aa86305962d05b4ea6dba8479208561f19d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0eddd73d72b31e3f7fd2a77543eb90a9cf78441ecab90e981f379566e2db90f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cb80f97b2b6de518bd0879261d92300719e13ec89ec55dbd40b1957ba93560c"
    sha256 cellar: :any_skip_relocation, ventura:        "b48f23dc2d494078d154d4859cc2fa4faeb1bd7c3baed4ff868c4f427235e5ab"
    sha256 cellar: :any_skip_relocation, monterey:       "cf2e31b7a73a0a4170876e1ddd31c66e9f4cb139bb30ffa17f66c1f7e6cf29ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9863426ebec2d13032de83251cafbd56fe1c99d281e87d448f82a0c3c30aa4a"
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