class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.6.tar.gz"
  sha256 "1cb119efeceec5b337027559f07b49d1d3cc77bee7113e4165c829c9ad053cf0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecc24316e4b622866d57b123ee56c02d9ab14b03a48757d0386bd8cfdfe70aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecc24316e4b622866d57b123ee56c02d9ab14b03a48757d0386bd8cfdfe70aef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecc24316e4b622866d57b123ee56c02d9ab14b03a48757d0386bd8cfdfe70aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "94ba22a9b6f688cc01811a32ab4da1920af6cb96bec1d07caea88dd565c91ed6"
    sha256 cellar: :any_skip_relocation, ventura:       "94ba22a9b6f688cc01811a32ab4da1920af6cb96bec1d07caea88dd565c91ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ff0b4fdc60c45cb55aa5a77ed78dabe7ad523515e556443e5ead6e7cce8ca9"
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