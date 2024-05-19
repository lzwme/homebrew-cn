class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.58.7.tar.gz"
  sha256 "785173ca80d304727e0db3dbcb0e0e54c3bdb9f66efa27a619e89e5b11aa6f12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0f3ce9d66d0628f0ef846922ba4f55b5f3a4a723647593c2f0a8fd1a3bb3e9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe8b6bb18d670709347bf2913908a0b6fabf573f8bc9b3c76b1a792f831b25bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04163c9874127c1aef5aa9e2a63ce98456c18546135ffdabd5d7d65ccac06338"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfc18169ee633f7774f68db61e3ee8c10a634562c865b621d574ff8bbd596b6a"
    sha256 cellar: :any_skip_relocation, ventura:        "0e91188f9adb36c50391f1b0e1af155bca199a9be10f6aa8c2923e70cf0c0966"
    sha256 cellar: :any_skip_relocation, monterey:       "ba3d6dcc8aabe00b935f1362dfae928fb5a404504080a711835a6f687089a7d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae2499bac66340f958c480a21b5c6caed0ecc7b2094d9cf96248211fdca6a508"
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