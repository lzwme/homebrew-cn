class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://ghfast.top/https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "646135646edd4b7717a06e95aa8dea85ccc19385db0df4e13c3fb7f7be85c539"
  license "Apache-2.0"
  head "https://github.com/gruntwork-io/kubergrunt.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c55447cab24d70343e2553edd152cd5dd134c62680fe138ace08735b6cef4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61c55447cab24d70343e2553edd152cd5dd134c62680fe138ace08735b6cef4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61c55447cab24d70343e2553edd152cd5dd134c62680fe138ace08735b6cef4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba407942115d5ee35a47cd89e13a1ecc0029884bf31ab2fdfcfc20b136754ac1"
    sha256 cellar: :any_skip_relocation, ventura:       "ba407942115d5ee35a47cd89e13a1ecc0029884bf31ab2fdfcfc20b136754ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0137a796ef71081d841b10e6bd85920557dbd5b060a081742df2834053e56e88"
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