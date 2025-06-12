class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.81.5.tar.gz"
  sha256 "b2af84537e01cc2f10d6bb9280d7957bc4d9faef44f1d49a492197b67afd21c5"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2eae8bd66c2f35f3ad77d38655e26bbbe615fda74b7716675376284abdb219a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2eae8bd66c2f35f3ad77d38655e26bbbe615fda74b7716675376284abdb219a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2eae8bd66c2f35f3ad77d38655e26bbbe615fda74b7716675376284abdb219a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8056d16e1c7d38356f60fe8a2503dcac7cebc4cf3a474501082a075e4f5d2985"
    sha256 cellar: :any_skip_relocation, ventura:       "8056d16e1c7d38356f60fe8a2503dcac7cebc4cf3a474501082a075e4f5d2985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "314605c08d90916f5094e7fc2e27b9ff400ea4bcb9db9d2e3b108447a416d2bd"
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