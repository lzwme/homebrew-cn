class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.64.5.tar.gz"
  sha256 "34ca9cd2b8b548b43997bad0bb3da318446c138c1b53ed74209efa3b232c5d38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "559e776637b89e48ca455c5a1981919fa591655f0aba57320979c01085d52dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "850ea781fce36fc8f6f8bc74becc98985b82714cb5ad7be1971bb261f54d7199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73991e4cdefd9b2caa1a00b47b0f02a5fc15e653b849ef4468e528bfa60d0af8"
    sha256 cellar: :any_skip_relocation, sonoma:         "609c17bd41edc074071f32c0a2f45ac1f49fe8d599e0af2a6b3a6f647c295406"
    sha256 cellar: :any_skip_relocation, ventura:        "6bc1d68a1479af6ce7aac2b2ee30474b0f60776dac455561ac2e7e3bc9b8a2b9"
    sha256 cellar: :any_skip_relocation, monterey:       "e7cbb2c25a0737c72ba4a737af71fcbb9637c10692e2f931679a424b04e22147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dc0073a1250fa98dac299247bd69957c9c1f12636ae05a7bfd798b20bf32681"
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