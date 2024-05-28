class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv1.11.6.tar.gz"
  sha256 "32a53c88b478139143eb8ff1a738604b06fcbb38d1978dc91f209307f7219f04"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef88ee9d631ac46ca69469554d9fb057bfe5e417d0b8750d3346a94ba6fdfe09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef88ee9d631ac46ca69469554d9fb057bfe5e417d0b8750d3346a94ba6fdfe09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef88ee9d631ac46ca69469554d9fb057bfe5e417d0b8750d3346a94ba6fdfe09"
    sha256 cellar: :any_skip_relocation, sonoma:         "46210156564d00afceb7a41a3a0cfca207643046c5f396f40153245fb42f0a5a"
    sha256 cellar: :any_skip_relocation, ventura:        "46210156564d00afceb7a41a3a0cfca207643046c5f396f40153245fb42f0a5a"
    sha256 cellar: :any_skip_relocation, monterey:       "46210156564d00afceb7a41a3a0cfca207643046c5f396f40153245fb42f0a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e28e605843decba13e767e2fdb0331dd24a7ce6b12739bdfc3414707a76f3cf"
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