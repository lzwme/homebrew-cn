class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.51.3.tar.gz"
  sha256 "f6c002d323108f4dcd8789b956481ba8ccf5c0c66c0b0e8535cf64c89c5046a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75606fafeede05f6a53e5351d95e056145ad6242f081c2a6659a4efc514624ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db518ad2043bd7f375d788d7b81ce84db2f04d0f980e601d7d9ad60b1994ce76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43544fdb17f17d1297c62365c891ca1435cc806ee1209115b78c3d8f5b6574b2"
    sha256 cellar: :any_skip_relocation, ventura:        "8afb4e0fb8b8dec47e950ae983ce237d40bf2ca6091febda54357d0c7744a792"
    sha256 cellar: :any_skip_relocation, monterey:       "98e9e3f7eea16598bae54e40903328ba6374a66f36a8ac5aa0a72c78d328843f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fb4c92fd3bfd643857b4d832755531f2841738d62dc99145bd2ec1dfe45eb16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "723a2518f7c646952832b310c6f92f39e6cedb640a2d2d969f3e3e12bdd61217"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end