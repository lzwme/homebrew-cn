class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.53.6.tar.gz"
  sha256 "7440e753be09725de9a8d2e775c41ff7bfe4ba2ca01a8d21444c1bbfd0a71bc9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac9af0fbe0029d7bf30c028dcc97042c8f95bb3e7192ef59a2a77db51a1b3870"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eaf8ff1f14f29bc9c0cb485b3b9f164ee9a46598945856f77d64e4738fc73179"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff817a0d571646b22c4010e109749f59d6d8d11ee2c4dfed46f93c4cdd87ae87"
    sha256 cellar: :any_skip_relocation, sonoma:         "f19b841f7539bef27b54783fa3fbe60fe5e478e2507443378e35c921ba9063e5"
    sha256 cellar: :any_skip_relocation, ventura:        "53fe2334b68ba2096625c949c25d507440b2d9f0c27651a7708d418e0ca79596"
    sha256 cellar: :any_skip_relocation, monterey:       "827b68021178e14cc862f6f85827405446d5822c946dae336239b530eeb5ed57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a64d550bddfa4fde6244d2af7aa9011fc5bd4fbc6a2aeafd7e659e98126546e"
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