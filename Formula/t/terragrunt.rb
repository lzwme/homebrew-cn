class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.54.22.tar.gz"
  sha256 "df7a64968e8b285ea3cd3e40b4610112fce206ef86ae476a512b04dbe003a2d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09ec833a26c911ffffc2a3c0980c718240ba0da721e5add985808c3830ccdfaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d8100a6f8583117c2a40799206365a4c8fe9a12bdff22e20f3009a3a844fdb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0b0fbcd86650f50ca241d22e96a270f06cf18d3fca305c1ff208dbbd2831d54"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a52f8af7da8beebf677db7aaffd8d517b5d3e0439da164b0e582bb9634230cd"
    sha256 cellar: :any_skip_relocation, ventura:        "aa8e799d5cd2964e23bdca734d09210fd4e5e9e956fd491405921506afb2da73"
    sha256 cellar: :any_skip_relocation, monterey:       "90679a9f3034d6837dfb7caf3d0a56a1ceadb3c777fb1f636d59fce30880e480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51e2397bfc6399a67d4f94b18cf3e56528fe24a7f9de9a062c760cec0cc0765b"
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