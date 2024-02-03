class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.55.0.tar.gz"
  sha256 "1c1d901fb4304bb836475773df469c38b7b8b137bbddba4c7c41de40ddcdc704"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "502f851bc52917a0a95d9725f886ae087d6d9b19526bced26c1461eb51d1bd65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2df777fc9a76afe0949abb572e4fb9f24b1533f7f9afe70f7a9ac49d3bd1d92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a71aa5b5f1fddd7ffc4a5496d517342829a4a228db15e53682f0a404c691ada"
    sha256 cellar: :any_skip_relocation, sonoma:         "b37749850884620c0879cb085463fb6e6b4d534cebba0444a3992fe7273c9ea4"
    sha256 cellar: :any_skip_relocation, ventura:        "e4169dd014fb3e2004e943a7b17aa8f2768db87469b1186fb8eac735583deb92"
    sha256 cellar: :any_skip_relocation, monterey:       "14fa2bbe559bccba2d63bf92d3ae3381f70ebdd1029d6ec2b5f0ba26d860c4a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8de6037fa6a2edf24be63edf0e59673326a94c8f856119c7e840fd2cb246f966"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end