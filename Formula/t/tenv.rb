class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.1.6.tar.gz"
  sha256 "59e30daba722a8a992b970520018f621f364f39222582890c2bcbae4e36c45ad"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "772071691631d21f38a77010da2ea010d58e435a6424423f1e63701c5e0295a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "772071691631d21f38a77010da2ea010d58e435a6424423f1e63701c5e0295a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "772071691631d21f38a77010da2ea010d58e435a6424423f1e63701c5e0295a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d893b2b008cb18a55e514f424bf0a998930df27349309d5e4f7bb8c4e3234eaf"
    sha256 cellar: :any_skip_relocation, ventura:        "d893b2b008cb18a55e514f424bf0a998930df27349309d5e4f7bb8c4e3234eaf"
    sha256 cellar: :any_skip_relocation, monterey:       "d893b2b008cb18a55e514f424bf0a998930df27349309d5e4f7bb8c4e3234eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2050104c5f92b78b430ba8590a2c9a4687310af91e66fb66620e11f5c2f03e7"
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