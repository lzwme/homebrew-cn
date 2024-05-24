class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.58.9.tar.gz"
  sha256 "f3dab30cbb75cb1e850fe4859b3a5b20fda7851c65f20aaa4475bd8c0f6e8a3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a7bf4370c5a88a82c118d408410404ca5d717ec5370bf30a79c3be7851ed865"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2c940b34c1cbe404f1f55a5000383eb842d5b1ea7b8c8cdec2d38f1883a1a22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c02d2ef328e30c408cb4fa4e2fc0e341272a93afd974e482a388b99df9ebb55"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2f7a29efb423671dd7ddb590177b08775f38729ab9611058e5142cff3a34f32"
    sha256 cellar: :any_skip_relocation, ventura:        "220f4fa04d82501bd71435e714a8aaf68e7bda5e42dad6f26c0b27bd2ca6df50"
    sha256 cellar: :any_skip_relocation, monterey:       "43cdd702f88943157078c068d50de53ef3243fa8eb3eb8adb1d5f86a46f4645c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "555f09e09489271dfb938757276dbcb2235c8f27e886ff53a02ca3b712b6ead8"
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