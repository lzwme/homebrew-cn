class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.69.6.tar.gz"
  sha256 "773afd1eaf1311fe63bfc766c5858049ac43752ef11ed2fc2f6084bb46f6e2c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "740fa8b7d5762969569dd4183b098a00cfe5a727f3eef4fe066760a636ecf274"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "740fa8b7d5762969569dd4183b098a00cfe5a727f3eef4fe066760a636ecf274"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "740fa8b7d5762969569dd4183b098a00cfe5a727f3eef4fe066760a636ecf274"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bf4d34a40247eabee14b5044b5c59fddabcd6e062db29074c548f728b9550ba"
    sha256 cellar: :any_skip_relocation, ventura:       "9bf4d34a40247eabee14b5044b5c59fddabcd6e062db29074c548f728b9550ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5151479ea66ffc0f16b04545081623bcb160ed31081919593450ddd9a861d7c4"
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