class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.16.tar.gz"
  sha256 "3d9bd791fb47dfc1b4dd9c8748e5a1543cbba634fc9b75b3674f3d57238fbe3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a3d48b35f3eae96cafeb76365e751dd76594294166c6882f9fc60f0acd6150f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a3d48b35f3eae96cafeb76365e751dd76594294166c6882f9fc60f0acd6150f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a3d48b35f3eae96cafeb76365e751dd76594294166c6882f9fc60f0acd6150f"
    sha256 cellar: :any_skip_relocation, sonoma:        "48d7b3c8ee56a944e4c34c0e41a9c0a4d09e726fdd69c6e7203a4fa66540a804"
    sha256 cellar: :any_skip_relocation, ventura:       "48d7b3c8ee56a944e4c34c0e41a9c0a4d09e726fdd69c6e7203a4fa66540a804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "820eb5c03121c36655f5a4b285b1f933dd50482cb158a7765a633e781d701118"
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