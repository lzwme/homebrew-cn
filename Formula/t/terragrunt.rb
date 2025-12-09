class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.94.0.tar.gz"
  sha256 "bcca1ecc698efde4e99560a2e6f539ebc4da606fc16df5c316b44b4525dc2a5a"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c57ce1bf7a4e02128788a7cfc8fb15c6227971112a53ca68b375e08820483e6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c57ce1bf7a4e02128788a7cfc8fb15c6227971112a53ca68b375e08820483e6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c57ce1bf7a4e02128788a7cfc8fb15c6227971112a53ca68b375e08820483e6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "db3804cc239e68c1fabc9505d12a6e8e686b32b70dbde56f53b3c29c93334887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08321b40182c541ca1ee86ba2beca357d12797ae940837ad6f032024c57744d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af0349e6dbc95d8b2365e8b0ba348aada486250a7322eb0cb8e3b57cc70acee"
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