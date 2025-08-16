class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.85.0.tar.gz"
  sha256 "4b0508803c01533f2820d96ae7df3b57928031848cd2fff4d1ae333cc6fec282"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c8e04dcd0352ad05011ea8f63a84bffdaa5e3584a8b5469fa137970a1fbd2d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c8e04dcd0352ad05011ea8f63a84bffdaa5e3584a8b5469fa137970a1fbd2d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c8e04dcd0352ad05011ea8f63a84bffdaa5e3584a8b5469fa137970a1fbd2d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb0985196e7f9acaaccc1927801174efbc64c5c3f529479b80eab13877481450"
    sha256 cellar: :any_skip_relocation, ventura:       "cb0985196e7f9acaaccc1927801174efbc64c5c3f529479b80eab13877481450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c5936013b0a7266365a7defed393ab3dbe293d4f8105a84e63a740845f7d7cf"
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