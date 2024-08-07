class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.66.3.tar.gz"
  sha256 "76b8021185cf29bc9b3110235f41e57295855c691dd9eedfb3d14bc2ac5c94ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8decafc9384585fdca6ac282da29ec272b25ac5f37e2023b4060281940c19432"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b8caec1d9223c3d57b73cbe03f8ffc052d2ade40b5b74e59f4458f5dd8a8678"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7afab7b4e6e4a4ae7f4a7e16650d3d240a89b1430d0aa4977359b8a683763a00"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0610cfee9b44b42dbcbd471cf494012f10af1d9e1bed17286f330b773177467"
    sha256 cellar: :any_skip_relocation, ventura:        "925a7b8ee4bb3d3f46de4790429692f0590ae22ca54ae08e319ca71485b36ad8"
    sha256 cellar: :any_skip_relocation, monterey:       "f8d3ee91bd0f4c84fcc6a1f613ecd7f5b9bb07cbc6f4fdb34a273e6ae68a67d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66865da2805b63dab59f8ef3da0e5bf9477bda0b247b3a94f15c69e132ef825c"
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