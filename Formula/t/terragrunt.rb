class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.93.8.tar.gz"
  sha256 "a220209936cb833872fe4252e294924eafb1800b9acf88cda4f20833f71ee2ad"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "577d39bf771f8c8ae3a2399583e16b1e776c59ba4bfda554b04a52ed48afd2a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "577d39bf771f8c8ae3a2399583e16b1e776c59ba4bfda554b04a52ed48afd2a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "577d39bf771f8c8ae3a2399583e16b1e776c59ba4bfda554b04a52ed48afd2a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b546c72bfc690df91d4b6974f6df1ea3b041525aed171bbff5d2e22bdfb69efa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf8efd45a9030a82e1726d17f58d4e511b2ec88d3c686762b3f351b6b250002a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "004e3d2006703e8dec78fecf55b0770c80cccf9015048edda28ad42216d37f7b"
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