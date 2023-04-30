class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://ghproxy.com/https://github.com/gruntwork-io/kubergrunt/archive/v0.11.2.tar.gz"
  sha256 "2cddf57363cbd8ad644e5793a6902ba6762b903133b5c4f0574c360ca011102b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9976cdbce119e9a00c67c548f7a1841006f092eef30c9f105735c11ffec9a81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9976cdbce119e9a00c67c548f7a1841006f092eef30c9f105735c11ffec9a81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "960491455003592d4a9d96c899e7ce8245268c032d478377b60e26d4bfeb939f"
    sha256 cellar: :any_skip_relocation, ventura:        "460f6036484a5173bc3b491dada47c3ce778da9e2f169a272d9aa21c7a302df6"
    sha256 cellar: :any_skip_relocation, monterey:       "49fad231ce509a823217db6bf602a5d85c601579010dd4535c65a7a75ced3eb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "49fad231ce509a823217db6bf602a5d85c601579010dd4535c65a7a75ced3eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9bf4b0d155874aa7f3c89aee80d8e440a2054e1d750b0d9bc0be16fdedce627"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}"), "./cmd"
  end

  test do
    output = shell_output("#{bin}/kubergrunt eks verify --eks-cluster-arn " \
                          "arn:aws:eks:us-east-1:123:cluster/brew-test 2>&1", 1)
    assert_match "ERROR: Error finding AWS credentials", output

    output = shell_output("#{bin}/kubergrunt tls gen --namespace test " \
                          "--secret-name test --ca-secret-name test 2>&1", 1)
    assert_match "ERROR: --tls-common-name is required", output
  end
end