class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv4.0.1.tar.gz"
  sha256 "71a9111d0310e37f097b7967c04f99f4526092dda98a2f922de6b45e2954a809"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd1347d1f18347f8d3b45c6e86b7c205a038eb46d05ce0ac48b13db2d7c78ebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd1347d1f18347f8d3b45c6e86b7c205a038eb46d05ce0ac48b13db2d7c78ebe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd1347d1f18347f8d3b45c6e86b7c205a038eb46d05ce0ac48b13db2d7c78ebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "71def02225730555eb10524bce22140c60aa9969b1848cd8ab287f3eb291127a"
    sha256 cellar: :any_skip_relocation, ventura:       "71def02225730555eb10524bce22140c60aa9969b1848cd8ab287f3eb291127a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07c9dd90514fccd78dc67db911523e906af92da6b5a2d91941a27b3e13908673"
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