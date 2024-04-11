class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.56.5.tar.gz"
  sha256 "67bb22dae7fcbc7df9bd7783d7f249fc581bfc3cf1258b55d601cac4e010aa8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce9a7810d8919e6855e7103447aa24b8ef75ef361d033e32e640a04ada145889"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7cf8763f9e9e87c7fa3d6f4f9911cc4fa5c53be2fb996b763bbf9b60a2625c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bad64596e325021d642cf3ba144e1697b61c5d1365a43ef944a236c46ed3da7"
    sha256 cellar: :any_skip_relocation, sonoma:         "203094f7222e0cf3c0fd76fdadd1959ee589f167cb0c8224f0dd4d7d6beec17e"
    sha256 cellar: :any_skip_relocation, ventura:        "6f17cf8f18aaf907f0bd1bb6403da0e6d9e6446d0d259185f0972795fa7f208c"
    sha256 cellar: :any_skip_relocation, monterey:       "85f63c25674a7cb36d138ead038d6959faa65daee291441005d02b8c3b769d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aafeebf9cd101d97a20c73ed241623c9f4033a99930b4b216d471ccfc315313f"
  end

  depends_on "go" => :build

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