class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.50.1.tar.gz"
  sha256 "3c8840e704407811ea05a951e58dca9a8f8027c3148a0226b2a00f938f88fe3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cd01e87305645ab098188c59f6dab2b05c247f19c618b9e0dc18e7e44d38d9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c243cb515d9120051f1d1423124336c13e021540b9d46e9e7fddbcf77e7702c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1be94809dc625361584964487a0af07d7fc066f9e1ea7d262fd11b140e1e6a4c"
    sha256 cellar: :any_skip_relocation, ventura:        "c2de5687389b6744732dfbc4eccff7ee7d10ec1e37af64f5ce8991e86bfe3ae1"
    sha256 cellar: :any_skip_relocation, monterey:       "50362a288f872a39b2d54e6a3a1c3f64a9724b47e455868587fedd78b6460105"
    sha256 cellar: :any_skip_relocation, big_sur:        "f456a5eb3d958aea07f96019ccf845a605b9520fac547133e63b244bb6dc5fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27b5b608cb2054ef60e7540a1a0233c84b7f1d717abd81bd4c28e157c8332e71"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end