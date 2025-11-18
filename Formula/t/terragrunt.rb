class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.93.9.tar.gz"
  sha256 "e227fb380c5f7c59ae4536aa1173970b6eadb551d9915c06e21b8db65d7082ff"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc281c89964ab79835405603b6e730d09b2b78f680a3da3ff1eeb904a9a7b8b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc281c89964ab79835405603b6e730d09b2b78f680a3da3ff1eeb904a9a7b8b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc281c89964ab79835405603b6e730d09b2b78f680a3da3ff1eeb904a9a7b8b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b058bf014a95ec5c5a45b9138a0dc95d8ae762879dcd1d78da7565ba0647a93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc0bff6593f67679fe3fb4eafd47651525b56a39e99026c1c2fcf9ad9d8992ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d850d7e51612e510706f35d2845a1fcc629da93537a5c33a582a84bdd40a1b5e"
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