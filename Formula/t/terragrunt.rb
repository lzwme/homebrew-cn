class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.58.12.tar.gz"
  sha256 "0d1ae09a01548c3a92590b2490a9f7f833dafdcd7ad17230ec5b57e08805a709"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bf5f29d6f351e8f170e8c49b2d45cf054eed6f75ab9df74ff996a83bc712c27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7a65277f24d953ddb4ad12c2d0abb45d45ee09be099785e1e6f97f65e51e1f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b60e7d59db33350c7c01f17b807d64c4196b4164f7ad3a8012bced8e9731b3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "512073ff240e70793c37e07eaca7893e04aabd2e8fa083e9f4cb0abb354000de"
    sha256 cellar: :any_skip_relocation, ventura:        "0669709c763640d64916ed725877382233bd2d1785af10d05a4c0cbf1109d0de"
    sha256 cellar: :any_skip_relocation, monterey:       "03920ef60121eb5e851e9e59f72ec0f6c326fb8796f860ca342aafcf8338d461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06f128963b1443b89bd8d2037d0d40bf9eb90405c293316dcdb35f3d8855be95"
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