class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv1.11.2.tar.gz"
  sha256 "99e129b29325716cf2ac8a8dc53591d783a90fcdffae488920a97a834c203601"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cd94590ff0cd26c6ecf9ee3a736d2560163f02656afab527759b4c2415b2755"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cd94590ff0cd26c6ecf9ee3a736d2560163f02656afab527759b4c2415b2755"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cd94590ff0cd26c6ecf9ee3a736d2560163f02656afab527759b4c2415b2755"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b35323b578360b0694b1a8295adf773811b7cb5252348262dff04ee8e0b3f68"
    sha256 cellar: :any_skip_relocation, ventura:        "1b35323b578360b0694b1a8295adf773811b7cb5252348262dff04ee8e0b3f68"
    sha256 cellar: :any_skip_relocation, monterey:       "1b35323b578360b0694b1a8295adf773811b7cb5252348262dff04ee8e0b3f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0db0ff0a6658f8b8a37be39b83ccdecf9d0e3d72e3844e95f6417c9aefa95d80"
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
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}tenv --version")
  end
end