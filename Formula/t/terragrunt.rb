class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.59.6.tar.gz"
  sha256 "8ea17d6b78687cfe9980dcd141340840ffe879aba75376d13f98c442a6096798"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "126f038d7e95026c8ace36a322df63494f709bcd3bd9cae54fb07ec321c63515"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a40b2a0e74f67b1b76ae82da67a5366eb39b4525410c636f6e7db66fc0a09084"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83cf007bb5362e35770bd524720bbed9edc4b0f5b4c392d58496754423ccaa07"
    sha256 cellar: :any_skip_relocation, sonoma:         "6068fd5b70d7fc0ad98e1669019d5e24f0a674cdb751f129fd99bd859e57f8f8"
    sha256 cellar: :any_skip_relocation, ventura:        "21dd366e88ba45f6bd3fafb26bb6f5c7b0650697832033ef4d15ca29406a1a86"
    sha256 cellar: :any_skip_relocation, monterey:       "85ae1f4c2a5aa11bb30c57fde648a6a97b8d704e4c420988cd4b37bfe8c1a395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "826a1d5ca43d5da4c6cfdcb75509761b1d410f7479b347c0549bf25f80f2b41b"
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