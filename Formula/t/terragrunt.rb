class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.8.tar.gz"
  sha256 "b5b7e95268b7f7f91088be859a236aa71496e999ec765497fb57928765532ddc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e2a7fbe06f5cddd8ae0d1fa68e0e829442cdc97a33dd2bce511196e909bec33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e2a7fbe06f5cddd8ae0d1fa68e0e829442cdc97a33dd2bce511196e909bec33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e2a7fbe06f5cddd8ae0d1fa68e0e829442cdc97a33dd2bce511196e909bec33"
    sha256 cellar: :any_skip_relocation, sonoma:        "fde377a15112b32f3cf2fc059300181fa4fd05dcd5f2c9f91d314db8073bd94a"
    sha256 cellar: :any_skip_relocation, ventura:       "fde377a15112b32f3cf2fc059300181fa4fd05dcd5f2c9f91d314db8073bd94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16fc3372709f03c4abd4b64aa14be879292ff60c41423f30e341f5b0d826d260"
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