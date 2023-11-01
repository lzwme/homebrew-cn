class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://ghproxy.com/https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.14.tar.gz"
  sha256 "7f74ec1ab67b09886918699e2076aef023bd1f6229036a793c8657f959ff9820"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31841f0c94595a7dc23535f77c401c7d0a7a751df5c836f267ef46426117c39c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d3a7a6ac4c609917ccd634fef9d4418fc748ea1693cdce56968e77acc2b4314"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a40a357c58d30ae6b406f8bf15c85343b7529c6e60143c77eb3db33641bbfbab"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb94a17ec48159776a7fd5fcddfd32a778cf65c12b5a599afa942ab7f6d41b24"
    sha256 cellar: :any_skip_relocation, ventura:        "6cc1b9b4ea058590c4105976a300ad0b89e50bb9d27da7ec09db13cf724fabb7"
    sha256 cellar: :any_skip_relocation, monterey:       "2bd27ca78c9d2afeea8750d1054d86bdf6e0fd62d1b56a85b4e7c5a3b24a874b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb3820d3fb5cdad2709fea7bf8a1067aa0a1339b35546175ea3d937d5b23ba12"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end