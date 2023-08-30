class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.15.tar.gz"
  sha256 "36a51e3d54da720c3174b8877f0632f3595925109a0ae645a95500ae182f9804"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9df5ca1d7f902ef3ac70817f8191ffd686a36102fca47771c39cfe71a94ed99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1de3a914ae9cfb7ece170e99ed787f92cd2bc72fdfcc7f80d5ee7308842a0dc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96ab68b39e3896eaef64e6692f14b07493455a747badbd3527e6f6edb01e2d7c"
    sha256 cellar: :any_skip_relocation, ventura:        "a64934bae4cee53aa893a492d8c153935f426011d9e211e985648599b87b4134"
    sha256 cellar: :any_skip_relocation, monterey:       "3d4301a75b22d5765fc0f5deb697d759f6e7f531634a8c559b83b3b975d91ab9"
    sha256 cellar: :any_skip_relocation, big_sur:        "730fa5e01ac4cc620b4b30c204b4e7404f0c73b7bd3c411f04fb5ea385dc4913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7494fabbb09c8a7d4176276b6b2a6a6c9db76ba0299bbf46854c3fbad5860b7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match "v#{version}", shell_output("#{bin}/kubefirst version")
  end
end