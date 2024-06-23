class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.1.8.tar.gz"
  sha256 "52f7b3525960f8b18486232ba4275b2c172bf0fbfd88294d0872ee8418934dba"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53abd1f5f9a3fe68bb7c9a160fd5700e9ca2f31ada19c758dc6cddeb6e0b20d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53abd1f5f9a3fe68bb7c9a160fd5700e9ca2f31ada19c758dc6cddeb6e0b20d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53abd1f5f9a3fe68bb7c9a160fd5700e9ca2f31ada19c758dc6cddeb6e0b20d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4520f0d202852d37a729b23b7c68838c2853eee68f459c31a5901a0c3945e823"
    sha256 cellar: :any_skip_relocation, ventura:        "4520f0d202852d37a729b23b7c68838c2853eee68f459c31a5901a0c3945e823"
    sha256 cellar: :any_skip_relocation, monterey:       "4520f0d202852d37a729b23b7c68838c2853eee68f459c31a5901a0c3945e823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bd38283ac1b6cc7a6aa26435875e782e6d8d52111f609f8dfbc14c860c81324"
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