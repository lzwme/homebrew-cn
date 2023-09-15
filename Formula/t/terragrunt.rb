class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.50.17.tar.gz"
  sha256 "f608f54da64898acab7e25fdd53e9431e6daecb6f954c813687e0e68a68f8374"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e951ebc18c9cf8c14d3583f917d764da933282b4e32d423f9b6411e0a2710391"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f07b391efba809eea26580516689df6e86e742c72ecc03ca78260fb8a1cc06a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "923cdae332e70133ec3de8b799fd3d99c1e4de9f305ba86712f2a512525859b7"
    sha256 cellar: :any_skip_relocation, ventura:        "a992a37fb374ed73695f9aa5246c5b2323bc11cad48b28486aa8b0db9472deb1"
    sha256 cellar: :any_skip_relocation, monterey:       "cfa7d3eb9e5c24e3b3571529b05210e29e5095f6d74f9c31bbfc346e3b7192e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe058a7bcfeb25a1dc96d126767ecd557e3b7632f102d421756baf0229dd0650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42969d5c89c4bf7c18ff9439b6f1d8c87fce47bf97f0996fa3d03695f3928552"
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