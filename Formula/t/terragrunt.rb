class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.3.tar.gz"
  sha256 "589843ac7c4da6429f7d40a67a0bee20776bdbc9db595cc2db67d09e0411b5cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28f9a9a7de070b7520cda3f417da155891cbd1391ab71af204b2d7aa4a1a7ca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28f9a9a7de070b7520cda3f417da155891cbd1391ab71af204b2d7aa4a1a7ca0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28f9a9a7de070b7520cda3f417da155891cbd1391ab71af204b2d7aa4a1a7ca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "99e5f61888f4c3915b49032d3d8d9d7b2c5a8eaff3191aa898915c719b0f48a9"
    sha256 cellar: :any_skip_relocation, ventura:       "99e5f61888f4c3915b49032d3d8d9d7b2c5a8eaff3191aa898915c719b0f48a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5bcf130b9653852aa7a4ab4691d2687397e5650ebef43272f156cf189bb22e2"
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