class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.63.2.tar.gz"
  sha256 "cfe84f1c19f550d2fe5d9a8853c4789f0382e4d67497c530bdb78180dca68642"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b846b844f0db4c1b5562a58634916f71339e14c8ec3c46ea32b0103aa2764a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a473112327616398f67bee4b2d0214d842569c3b44546ce26a29ec9234b983ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ea72f541045394d7b62ffe50dc24092496ef37f1916a9997871616fc5984ff3"
    sha256 cellar: :any_skip_relocation, sonoma:         "370f41c6383b4cfc9b1428ae6fb6ee73ce9331e70e3bfdfa3f50c60f2ad2c000"
    sha256 cellar: :any_skip_relocation, ventura:        "ad02370006325a4bb59073f3803d206441ff01d6ca7092282a9760aed34aa9ed"
    sha256 cellar: :any_skip_relocation, monterey:       "8aab1711d71e13489bd72dbeb6f0197b946e1911fab991d89df6de31b58e7a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e401d259604a88e23fcefb046fa49010629fe4ca6cf8bd2fcf96338c2c0d1d49"
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