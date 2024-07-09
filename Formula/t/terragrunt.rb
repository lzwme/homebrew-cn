class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.60.1.tar.gz"
  sha256 "de85b81955933e8f2fcc5e3548234d6b86e3bd18996e52ea7c9edcd601c9c351"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ba6fd2f6f0dcb346f96c61785770f948301cd39ff5397eddb5d29d2f056a9fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "412758ba832c0aec5dbc6203910afbbd2fdb2698c3aebef0b1019759f4250f2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e583a5a84e12ada190f70e53fbe644fefc4b1c6a8d1ec0ef3d1a089f098a4b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "12770c5c783720ba8cba35c03ae8ce856ec376cbd348a305701350c8f6733c9d"
    sha256 cellar: :any_skip_relocation, ventura:        "94ee4e4363c3011b55ebdd6fdf92d30249f17267ab530df9b1a0eda34854474f"
    sha256 cellar: :any_skip_relocation, monterey:       "a8e925bbb831bf45f3d27a56d223b86a3e30ab47e12a25558a626d8b0c492fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9be3576b050c687db0e705beac2456635271a1f5cc5e65f9394ddbaa408995d"
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