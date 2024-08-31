class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.1.tar.gz"
  sha256 "1471e816b624c7a8c2ba58ae234536317ec9cec349f983b5177efa24d8dc379c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "008ba2241b7d263600e55d753ba4ded5a82c87f8d7939ab8ca326cf051a66eb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "008ba2241b7d263600e55d753ba4ded5a82c87f8d7939ab8ca326cf051a66eb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "008ba2241b7d263600e55d753ba4ded5a82c87f8d7939ab8ca326cf051a66eb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f546f433598afd2a2ca953c24868cfda44b9f5698a6fca72865adc461e1a277"
    sha256 cellar: :any_skip_relocation, ventura:        "1f546f433598afd2a2ca953c24868cfda44b9f5698a6fca72865adc461e1a277"
    sha256 cellar: :any_skip_relocation, monterey:       "1f546f433598afd2a2ca953c24868cfda44b9f5698a6fca72865adc461e1a277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bdf0aa1efd8d1abde3e9f7843c4ae60d0cbc50a88c98aedb781a35d700e6e16"
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