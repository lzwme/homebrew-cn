class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.62.1.tar.gz"
  sha256 "9070d693f88b0ffe709bf7ac3f51ec3218f7fbbaf8eab25eba748adbbcac639f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2c7ff23ff81b9faaf76de78c3a25c24bf7a4300476dde1f9c869784bc915ae7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef69ebc80bb60120fcd08559dd4eb640b23e9dc35bd607167b3ebfd51866f501"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "404dc439b993989cbbf42429eae98ecee215221aef804a2fd8a31bd2f21640ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "955b62b1f244fcc5c2f9a572e8ce05bf2a255098584144e3f74512b698a97697"
    sha256 cellar: :any_skip_relocation, ventura:        "b38b26a38ccdc6e1936021e39f671c4407b500bd4a9c8fbafdc11c2dbd682007"
    sha256 cellar: :any_skip_relocation, monterey:       "2750d6baa0f009e998f75b28a874acc3ec3fbaf47ef73e4e331ef9de36501be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55ace3d9aa9c47870e99625118894d8f14cb64c697462b3f9328b2f72f881a83"
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