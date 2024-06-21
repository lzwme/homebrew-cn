class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.1.7.tar.gz"
  sha256 "b28877a2a25f00904580b7944843f7ebe207db77d2173dbb5926e09a87d3346c"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3f74d94ccc5d6350d84a40c26b0b439be56f0cd219af3203858b48bd10eb778"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3f74d94ccc5d6350d84a40c26b0b439be56f0cd219af3203858b48bd10eb778"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3f74d94ccc5d6350d84a40c26b0b439be56f0cd219af3203858b48bd10eb778"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1c6700bef3bd2ccb939e6d11b808ff4618d9df40e64f31f10cfe7bb8bf56b48"
    sha256 cellar: :any_skip_relocation, ventura:        "b1c6700bef3bd2ccb939e6d11b808ff4618d9df40e64f31f10cfe7bb8bf56b48"
    sha256 cellar: :any_skip_relocation, monterey:       "b1c6700bef3bd2ccb939e6d11b808ff4618d9df40e64f31f10cfe7bb8bf56b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d56e08d116922c3d50aa066f0584f912aa10bc2c865ca4d76ab4b825ea8c18cd"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: binf), ".cmd#{f}"
    end
    generate_completions_from_executable(bin"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}tenv --version")
  end
end