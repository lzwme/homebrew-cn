class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.69.0.tar.gz"
  sha256 "6a6bee543759b574089f983ee309bf2acca9dfa6ac9058798fc6d09dbe3cb860"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f02642c3cc4f68fbf524d39fa1b3b47b873584fe3cf6b92c94ba06c31d23e4d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f02642c3cc4f68fbf524d39fa1b3b47b873584fe3cf6b92c94ba06c31d23e4d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f02642c3cc4f68fbf524d39fa1b3b47b873584fe3cf6b92c94ba06c31d23e4d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "445002246d50c8a01cc5fe7427a1e0115482aca708c6ebba5757662f59344d58"
    sha256 cellar: :any_skip_relocation, ventura:       "445002246d50c8a01cc5fe7427a1e0115482aca708c6ebba5757662f59344d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad9d5b71d3e8cc85f08616d0cfbc740de1764b327da1dde217b7286d09ee845"
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