class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.54.3.tar.gz"
  sha256 "d0cf22f9169caefe9477ff0aa54c62165b52a6b14002e5536913d770a6745fa8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cfb6ef87123bc140a9d913903168ecf07ee3b4fa6aea27fcf2fddd90c1c31e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d859bdc46b5ccb2871afe9a1cec9d960319f2dc6979fc7209a14d55caf98733"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef3239f318915ba04f3d53653881e2ed4c78980f4ddb904a760b87931525a2cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bde0d3227e18bec63a40fa240af8747aef85ffcb03db437a738138114346ad8"
    sha256 cellar: :any_skip_relocation, ventura:        "59741c2f68766f365c2e572747a7283fb609e7a1e767d6522df2197480f75e72"
    sha256 cellar: :any_skip_relocation, monterey:       "38ce2552d309a6300d5897965339e1cc72d5069535cee0eabd9841362387e3e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bb8ebd832533357b9218ade2eb75cdaae0399d26a2c8d90e4291731fa622d7e"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end