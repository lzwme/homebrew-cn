class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.54.7.tar.gz"
  sha256 "07a6fb73bb398ccd893ef27021ff037a2a157e2453cd29787d6f6d199f8fa0a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df32e812c36de3be0bb8d6e83cc2227c9b7e86ebdc5344f3846f850f7bdd7254"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7a365c715ff8e2362ea84ec4da9acfc5dfc35fc3567275022dd66f7cbf06d7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b95a1b6078871bb40bc66f0a3aa25c9f9e22b58c7efb43412267cf6324ff40bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d6c49fd18117ef521190a7dd82d0287d568e05a6810f8c28230825c10f47468"
    sha256 cellar: :any_skip_relocation, ventura:        "53408fd5832711fc3d3770b8ca45e8b04573fc1279f185f8c36f5608f9f9a5dc"
    sha256 cellar: :any_skip_relocation, monterey:       "1c7771b3d6a02a03c7b57bb4b316c432bd93329634cdd8ccdb55a15cbb3e8803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d01ca0b7bb505df57633be8630b2a32d18c5c1d625003b1efed6e22e4a56bc4"
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