class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.57.12.tar.gz"
  sha256 "991c5faa53a8d2bb767e9fe8ef69f2102269f380c3037dcea626b8028ee2ed35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71e6d91aa7d2633c999066d3a1b70b851dc041db07f111d78be51e8bdf2d0a42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ced8daf877f10788a781fe98cb58966ea671c4cff2c21b22bff8841bd7554670"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7968818ed999bbec6c88de0e61152bd9fd6a2f951c02efd9f8d1402009820244"
    sha256 cellar: :any_skip_relocation, sonoma:         "f24538ada0da342f545d7469b24b59b59f73ae7f18cc8f08e35d4506ead8b922"
    sha256 cellar: :any_skip_relocation, ventura:        "965b01a63bb9da605aebb16ce993d10e3bfec2d0d46f95147204310a649ad63a"
    sha256 cellar: :any_skip_relocation, monterey:       "57bd79265639e884aae938ae909eef556f6d6327b45e34280bd002dc2cb4b671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98e33b6d4d8529e0ff865b3a6289fccf3a4b834b920ec505ec0f00c9fae2cfc4"
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