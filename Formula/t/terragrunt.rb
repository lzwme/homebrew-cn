class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.58.3.tar.gz"
  sha256 "8c8eb62823e93881f55168860727918e334326eabcdb018fd78747b07544ee3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3ca7d1195c0adc9f7f85a64937317a18c20aa329c506bdb5e06b0b3c7d37558"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1a86956ecb4daf6ed87054ddc4f801ded3e6188ad657f18e344f4135a4879e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80f16cdd1904bd91e8a2e537ec89a2983a221d0242bd9d7d5594090f9c3099a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8407814094307f94c18de7ef640b823f33d63b086740bb315919cb17245105b"
    sha256 cellar: :any_skip_relocation, ventura:        "c39cb83b3c24e568061a7c6e21cef6eb95bd6692c9b279e90d96801bb2d6c02c"
    sha256 cellar: :any_skip_relocation, monterey:       "1e23cd094ebf8a6fe5ee3824b8591307fdfcf31abab991cd9c34e7b7da5a7d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1063bd082bd95ba4e34a0ade4d81b77c0e4f01e9093bc5f93ad8b7eafdb021a0"
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