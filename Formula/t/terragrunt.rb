class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.54.20.tar.gz"
  sha256 "945c2d32c053553ecd319ab4ce4f761455e666cfd31564ced3ae83416166ed42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b03109c4a3bdaa511deb332e14a5fe5d5f8b7a6f9cad9cd09a27ced78e9cef94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "088372c3ed4818719bf7bc9f1f5caf66e981a7e90fd6534d5215829b6e479342"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27f77c811a53a6611af5a9e36308bc77af97e8367666ed7cc66cd669475f4c88"
    sha256 cellar: :any_skip_relocation, sonoma:         "c226372df70e6a00f83a946f1a484c71f81c6eee46a477af5bed871e434ffded"
    sha256 cellar: :any_skip_relocation, ventura:        "d1af98f784e2bb443403c3e3b6bf153270585b55ed042a0af3f91a2398891cca"
    sha256 cellar: :any_skip_relocation, monterey:       "450202e3791f45a0a66290bcc5feed8e2dda02826af2b35201dab868dd93d3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc7ba918b1a7d65dc002020a2693eb746ee86bf20f5f7db74a82b477dc37ba16"
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