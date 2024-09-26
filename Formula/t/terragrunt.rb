class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.13.tar.gz"
  sha256 "7a4ccb5779e42b43882622b5a093a262e9f917c77706960f5437b8896c0f80bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88804b6511154f913cb18296bfd4339b4379eb46d07eceb54c2cddaf4457c65f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88804b6511154f913cb18296bfd4339b4379eb46d07eceb54c2cddaf4457c65f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88804b6511154f913cb18296bfd4339b4379eb46d07eceb54c2cddaf4457c65f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a342d79af3527c6da6d9e3449728c07645aa84aa0ffedf36d2a2300317b5328b"
    sha256 cellar: :any_skip_relocation, ventura:       "a342d79af3527c6da6d9e3449728c07645aa84aa0ffedf36d2a2300317b5328b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e551842f727198b75fcc5507cff98c7f288cbe1e5d9eca3859527f93e88e146"
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