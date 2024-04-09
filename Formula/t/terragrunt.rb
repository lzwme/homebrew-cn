class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.56.3.tar.gz"
  sha256 "2653c42aec737f67a3fd4f8d3b79b4ecc18753cfa7e88ec5b0ecd6d5adf58e94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b31d95af0ebcdab5ceba3e50c9e1d8e55993d09d7a659dc30829e4c09484a045"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66228b5650dd5933e7116e6950f46d31e20211d9d2d6c279190756f716f9684e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ef9687cecaddf9119a3c95845b67e0ce82646bb606e5b4a40939e0b51e82ee8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8900a8a149bbb595196c096ffc46a60bcb8cb38aaa7125fc0039f2befa6dffbf"
    sha256 cellar: :any_skip_relocation, ventura:        "99cef56882dba66d0cb4e5bab35a620a58e1c0ddea1a5c5644e6bc34a4a38647"
    sha256 cellar: :any_skip_relocation, monterey:       "2a55b0446959e9b2fd2642f6018832a8bf40a0eecdaa2799e6f028c7df3876d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d8a293a5376b0cbaef0fb8f25c4c8bf661c6af769a5ee3f9287385a02cfaf0b"
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