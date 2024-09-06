class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.3.tar.gz"
  sha256 "b8d474a389d17eb126bbe5dc96321243a0ade0b449967710b85dbf088b1e1f7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d0d2b75f5289b44e5181e800bde21fb0300b796fd8dffcdc60c52855355a793"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d0d2b75f5289b44e5181e800bde21fb0300b796fd8dffcdc60c52855355a793"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d0d2b75f5289b44e5181e800bde21fb0300b796fd8dffcdc60c52855355a793"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e635039d5e667213f75dde604846bedb1bb8a89da34053fac2790fdfc09c4ae"
    sha256 cellar: :any_skip_relocation, ventura:        "8e635039d5e667213f75dde604846bedb1bb8a89da34053fac2790fdfc09c4ae"
    sha256 cellar: :any_skip_relocation, monterey:       "8e635039d5e667213f75dde604846bedb1bb8a89da34053fac2790fdfc09c4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e6c5b9d125b2df3dfff9100bd439c6a1d1d602ae9a4cca4f83d0dfdf67883a"
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