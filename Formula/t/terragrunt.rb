class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.57.13.tar.gz"
  sha256 "72729af79dadd2154d1e23ec3cacaaf298d16f814eff38d09f193128f408aadc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1605bdf71f38095efad16d5e9deb71b7490831e697a28ca5dfe27dbec63546c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd65593f23076ee2101981ff9a8cd59f9e52138cc92309eba21863a079f10b50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a508dfcceb8f16aeecafea56d1a32759fabfc4d47fdb159f62e9959bb437d0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d34998ff923340b4ecc22044cdafb46ae76c19db707a2ec5be34dac599f795a"
    sha256 cellar: :any_skip_relocation, ventura:        "db2a4853d37ff5e3b3fb6891f3671234627ddb83ba00495cf4f939de7c996bcd"
    sha256 cellar: :any_skip_relocation, monterey:       "9fac93e7576d1963f7670cc64dccc8db820e2784a53523fb9e69b2a7bdce74e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e707854990848b77b3f5b88554f54b339c11967290571897227f0690f9885782"
  end

  depends_on "go" => :build

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