class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.50.9.tar.gz"
  sha256 "157f7c5489fdb9ebc033010d8d62f1498f887cb112a510d39a66f91330ebcd69"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5739d3b3c14f4714a7727a642d4097b64be781e0def1778df40cef2a5388f61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afa947eb87f6971e8a00d8ddb5eeb69c2ea2b4ed42b424dc0a299cfa2d5bbe06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b1d65ea1d8eac6861ca144db5e76de14abf6de7db3fb61ca67cae3bf3cc5c4f"
    sha256 cellar: :any_skip_relocation, ventura:        "645bbfbe231fd7c6cb276ba7364272aed6f94139ca6a1f272a2c87d460768722"
    sha256 cellar: :any_skip_relocation, monterey:       "daf94dfb802c1acc4e6cf7bef67e87e43730ce8e33ac133c41ce2a8f875852ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "34aac03e019060a06e74e3a8616112ce6502989b1b6337e0cc1a66e356c02cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eb97bd9ecc6599098481b3812ef72e569bb5520f2544e904e2e5e23e9d28c8f"
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