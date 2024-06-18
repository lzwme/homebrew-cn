class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.59.4.tar.gz"
  sha256 "71b294011db536c3700bfee24c4d2f8e7af9721e9f69a2d06c3f6033fb7a8c5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f5b327a6b247fc3bcdc0c2d0079d8ca50634ce93777fccb0b44fd629ed886fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d53254260390536fa0a7801c4cf49026afbb43420c50fd7dc8d7f526d1870d72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f45eda930298ccfe9db806036dd760548221c59b995322ab61bb5028b84b22d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e424f5d1a945516a0f5576ddafebc3dc66c81c1776b9becf4d58035a807645bb"
    sha256 cellar: :any_skip_relocation, ventura:        "bea5148cf4d87f4888fa441fe406a695b5ea2f991e54b9182e8acbb7ce61de03"
    sha256 cellar: :any_skip_relocation, monterey:       "cfcccbb85f4caff1e649dd3e8dd5be7502ca1ebde45ebfe6359af22b97f8a95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceadb7fb8f8c58f6a78f68c488b83fb01e96e38e3137e19b600cbe97731bdc05"
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