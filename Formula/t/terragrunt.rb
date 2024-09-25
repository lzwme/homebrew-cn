class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.12.tar.gz"
  sha256 "9c9f75532ae40546fa2fa27e29665787148bfac8d16cc0eb29882ac7ffe005b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87ba0a90de2d5a9936254234cdf7b21b3492e646a00dd0f707cf0848be37c19f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ba0a90de2d5a9936254234cdf7b21b3492e646a00dd0f707cf0848be37c19f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87ba0a90de2d5a9936254234cdf7b21b3492e646a00dd0f707cf0848be37c19f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c484cd758ef72006dc68991175d5602ca36439c1fe204098ccb738edd2b420c"
    sha256 cellar: :any_skip_relocation, ventura:       "5c484cd758ef72006dc68991175d5602ca36439c1fe204098ccb738edd2b420c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e78a7c2f82160bd8fbe599611e02756b7d561b635c085cd894ae48dba68cfff"
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