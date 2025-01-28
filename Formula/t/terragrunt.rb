class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.72.5.tar.gz"
  sha256 "7d10529e2e65559eab70fcb07d58788dbae2626d76a01d1f37fe8f832b68d1fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "798258c29733c5544abd2e72a6223bdecf376167cfe735efabb4d630679c870d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "798258c29733c5544abd2e72a6223bdecf376167cfe735efabb4d630679c870d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "798258c29733c5544abd2e72a6223bdecf376167cfe735efabb4d630679c870d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc353bd0b04e9a31b3d45717068b41a2df9dd03094e22e642f9ade85bf8d0fd3"
    sha256 cellar: :any_skip_relocation, ventura:       "bc353bd0b04e9a31b3d45717068b41a2df9dd03094e22e642f9ade85bf8d0fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d1e431325dec7280b73ec9f77e2036ac1beed1f39bfd74637acfe7a852e0a21"
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