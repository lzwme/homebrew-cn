class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv3.2.8.tar.gz"
  sha256 "73e21934722a92449d3c1fef819cf9d92478b2470062f5c527b70b2535693a2a"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1a0cceabb6b82e0b5b397e91a828abb140c1e14c73b10aee755221b140b8126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1a0cceabb6b82e0b5b397e91a828abb140c1e14c73b10aee755221b140b8126"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1a0cceabb6b82e0b5b397e91a828abb140c1e14c73b10aee755221b140b8126"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae9cd06b7b7d29908386419fbb5cd0faf7e5f66cb755c257aa8654d4a123adf3"
    sha256 cellar: :any_skip_relocation, ventura:       "ae9cd06b7b7d29908386419fbb5cd0faf7e5f66cb755c257aa8654d4a123adf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9043b10a0fc5724278c80083ec0a98355c7f77c14efb5c019dc81ec3cd4f363"
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