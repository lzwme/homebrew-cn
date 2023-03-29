class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://ghproxy.com/https://github.com/gruntwork-io/kubergrunt/archive/v0.11.0.tar.gz"
  sha256 "b3f46010ca8d0c01e7732af9898ecaf6844ad9b7e907d2a0a23cb4e76c7086bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d316525828bbcdba7621c2a3c8eed28b16c6ebe36bcf6c4edb1f930cd5d96922"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d316525828bbcdba7621c2a3c8eed28b16c6ebe36bcf6c4edb1f930cd5d96922"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d316525828bbcdba7621c2a3c8eed28b16c6ebe36bcf6c4edb1f930cd5d96922"
    sha256 cellar: :any_skip_relocation, ventura:        "b1a3ca2f84cf7d180f987b4d14c0800f073aa007de9896e56eec93d75de8c51f"
    sha256 cellar: :any_skip_relocation, monterey:       "b1a3ca2f84cf7d180f987b4d14c0800f073aa007de9896e56eec93d75de8c51f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1a3ca2f84cf7d180f987b4d14c0800f073aa007de9896e56eec93d75de8c51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd9b80c44b1cdce9075d9d3afcb626035e127ca81b642a4871272aee6b40b37d"
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