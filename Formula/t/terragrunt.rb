class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.72.8.tar.gz"
  sha256 "5db2c906f4953bb83c4079d517046856718df872be70423709d607131402e739"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24f1b0eaf0d7a34d992888af3ba80ecc73c80ad4a112827c753024fd0cf6708c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24f1b0eaf0d7a34d992888af3ba80ecc73c80ad4a112827c753024fd0cf6708c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24f1b0eaf0d7a34d992888af3ba80ecc73c80ad4a112827c753024fd0cf6708c"
    sha256 cellar: :any_skip_relocation, sonoma:        "de61ef585637b707fec9e2abe6547dc98584c1da34b38c633de4e27e3c2e17de"
    sha256 cellar: :any_skip_relocation, ventura:       "de61ef585637b707fec9e2abe6547dc98584c1da34b38c633de4e27e3c2e17de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7f1d0898a584b798ce1a723eddf2aeec8f1c18e61a457847f6de22758b36017"
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