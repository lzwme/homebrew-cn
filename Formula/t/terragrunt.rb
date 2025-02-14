class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.73.2.tar.gz"
  sha256 "772ffdcb8d80054dc0a218c587b7a304156eb9860ac6abdd082b0203d177c62e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23d443380f9cca91afe590cfa60c919ac9a1b738aa5b6d41321d10150725808c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23d443380f9cca91afe590cfa60c919ac9a1b738aa5b6d41321d10150725808c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23d443380f9cca91afe590cfa60c919ac9a1b738aa5b6d41321d10150725808c"
    sha256 cellar: :any_skip_relocation, sonoma:        "35c27ffce3531280f38506759bd3c9204eafae7c652dacfd49f662657288cdf9"
    sha256 cellar: :any_skip_relocation, ventura:       "35c27ffce3531280f38506759bd3c9204eafae7c652dacfd49f662657288cdf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e08c531b0dabcfa5d55e3a8551eefb35ab43bed4efba7fc3174ede384e2a761"
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