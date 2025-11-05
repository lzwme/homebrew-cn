class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.93.1.tar.gz"
  sha256 "06d9cecfa45b77150fe28718c50cadea6208ddf0b1f6c68d96010449e9374074"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "338624d6c0d0d865d0e48864e17c8af705c7dc83ebe719a7daab312a9e495b8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "338624d6c0d0d865d0e48864e17c8af705c7dc83ebe719a7daab312a9e495b8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "338624d6c0d0d865d0e48864e17c8af705c7dc83ebe719a7daab312a9e495b8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b959e7e6eb29d41cc0509d5125972b689dfaee58626c6078ca5b853e9a2e6a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5e9f8b2ae63025da7191fc538b37dfabe7b9ee26db686d468cc022eee0b5aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2785e206aa503eaaa879db7d91e5f0d2db5ceb42bf0a7852af7e06f7b976eeed"
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