class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.2.tar.gz"
  sha256 "46dc53cb6aa57250478d835bd0c448cd2ec3a3a6a9196cfe69223910a024f1fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f653c5277aaec7c9fa151c8b789bd3747026aebc7b75608a4c1ce83b817d8bfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f653c5277aaec7c9fa151c8b789bd3747026aebc7b75608a4c1ce83b817d8bfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f653c5277aaec7c9fa151c8b789bd3747026aebc7b75608a4c1ce83b817d8bfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "94095115b198e03f33f7d832cdc9529b1bd74debb763c8671a0df056254547eb"
    sha256 cellar: :any_skip_relocation, ventura:        "94095115b198e03f33f7d832cdc9529b1bd74debb763c8671a0df056254547eb"
    sha256 cellar: :any_skip_relocation, monterey:       "94095115b198e03f33f7d832cdc9529b1bd74debb763c8671a0df056254547eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77ac5d62c6f7ae7c590d4eb7b1040d1b2d3f76a1bebfc0ad6ff63a90f43f9470"
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