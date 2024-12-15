class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv3.2.12.tar.gz"
  sha256 "de1fe072d75408012a4886b793de2e5ee15c2d598ce28028f971937b5cd12252"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43ef373563b740b41d564218d7b5bc0d2bdb32135127360faaa56f2774b8f5a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43ef373563b740b41d564218d7b5bc0d2bdb32135127360faaa56f2774b8f5a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43ef373563b740b41d564218d7b5bc0d2bdb32135127360faaa56f2774b8f5a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "86647597e24df6fcdcb2e4a58c3a7ccca1c31e0c14e2f93ddc1d4b0b8df06b6c"
    sha256 cellar: :any_skip_relocation, ventura:       "86647597e24df6fcdcb2e4a58c3a7ccca1c31e0c14e2f93ddc1d4b0b8df06b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "962632970a0c3da7d88b51d24e84e6824b42540c801d0b51507b6b80a15409f0"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
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