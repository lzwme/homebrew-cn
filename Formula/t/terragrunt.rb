class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.8.tar.gz"
  sha256 "f7a57a9b3a029a49cf4135469d8ca50e67b5f487cd201cf5acdc93091ece8e15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3ff6a94879b9e25c8266d55ab006af01761725df7f007d36fcf322f87f0b6a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3ff6a94879b9e25c8266d55ab006af01761725df7f007d36fcf322f87f0b6a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3ff6a94879b9e25c8266d55ab006af01761725df7f007d36fcf322f87f0b6a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f14eb0a7be9c5404034afb782e20067a3940dba37e5aa4ffe6be932fd346a789"
    sha256 cellar: :any_skip_relocation, ventura:       "f14eb0a7be9c5404034afb782e20067a3940dba37e5aa4ffe6be932fd346a789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d61953db12e937e664814d0dc26ecb9a8806b71c5dad8d8952e2c21941c3698a"
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