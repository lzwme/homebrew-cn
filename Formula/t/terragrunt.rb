class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.58.1.tar.gz"
  sha256 "1ce7d68439c2b19550417890c04911fb10f1a7dddeb82947f485ebf198c86dc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f9630eaf4d374dea97ce6f830afcd3589a767a4409cb32804343858f8f24e5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91bfd9954621ec127d95fbff4576a6ccbd8f2ccf389dd34712b390bc086639ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a21858a900ab36e9fd250296d773dfd9aeec3843696dcd26573c807e4270e1cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "8add3a3820e2b10ac0b29ecfbe2d8e2b4208ea34c671585063f521c9a4841ae1"
    sha256 cellar: :any_skip_relocation, ventura:        "e4a91ffa69165b84e2fcfc2985e502ff64521b3f5d4b6168d34194e3fbd93a0b"
    sha256 cellar: :any_skip_relocation, monterey:       "ecdabafe78681be3a15689f9e3c2764779d46c45f623ac61abb4545cadd82a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "546d16103c5209970d2237e70a09238eb7348f51ccf42883f6a9c14f8fb21455"
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