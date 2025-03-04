class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.75.0.tar.gz"
  sha256 "fad8f3aea64868689cd23e868bffb89e72aedba4b9533c00ca6b9ae9de8b478d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "425512de4547f522b93a52bcde724ed6aaee23139c75be96c8f698ece3dc1395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "425512de4547f522b93a52bcde724ed6aaee23139c75be96c8f698ece3dc1395"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "425512de4547f522b93a52bcde724ed6aaee23139c75be96c8f698ece3dc1395"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cd9cd4dc5cba9d5579a3fc7230eae031a8303fa5ac7e2d42b933945c17e0983"
    sha256 cellar: :any_skip_relocation, ventura:       "9cd9cd4dc5cba9d5579a3fc7230eae031a8303fa5ac7e2d42b933945c17e0983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2bc6aa62c637b41e61b44b75909426104ca8b891c9c65d0cb70f6ac3b356536"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end