class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.86.1.tar.gz"
  sha256 "971d7b62fa3bfe75962939565d309312df2c0c1342fd946c1c81029bfecd23b2"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e566c7bad593f3a5971b2cfbb73d8e35741c14bfc77063b02c2f3fce3cade351"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e566c7bad593f3a5971b2cfbb73d8e35741c14bfc77063b02c2f3fce3cade351"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e566c7bad593f3a5971b2cfbb73d8e35741c14bfc77063b02c2f3fce3cade351"
    sha256 cellar: :any_skip_relocation, sonoma:        "bad6972dc51da439a2303a08dff1ccf5e87a3462a217197764eaf347f546d94c"
    sha256 cellar: :any_skip_relocation, ventura:       "bad6972dc51da439a2303a08dff1ccf5e87a3462a217197764eaf347f546d94c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4c93cbb318458a87a940145926a979ba6ee4af771890d6dd5f2d6e3999b4431"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end