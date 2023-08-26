class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.50.8.tar.gz"
  sha256 "be5800abc484f513b5f3862074ddd6843623022692ae434eccc6a388ace00c39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99f56f2fd97c451329086ac0bac9b251281972546aa720950baee846b1404ee8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04df632c675a004e7154d850ccf1246f38b076ac365617a67a4a0e4ef62ff7f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fb8d2eab1f10016d52a1a168a69e887c68f2296ce10a2e8993f7b5698e34dde"
    sha256 cellar: :any_skip_relocation, ventura:        "0a21d0a95ba4f5a43b2a7dcbb36e4e9bd19bff218217eddaa2722d21d380f09b"
    sha256 cellar: :any_skip_relocation, monterey:       "8c6ba883667ad678911b9fbb733083645dea06060b9ff50ff98c1aa0b95c60a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc65a36d256e3d4031843a57c0c2f5539e5376b3eb962f129593f2fd4df96f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05c8c5b8e2ca32d36415fabf86ce0caa52f0c0151448c61b969f03a155c1333c"
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