class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv1.11.5.tar.gz"
  sha256 "cff843b2bf3af551b8cca9ce07f96dfb8f028648e4cc948c0db30acd9af8090d"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f588befaf66670b1e9b8e1d551ec39f6bd22b316116baccd4d27995262c7a789"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f588befaf66670b1e9b8e1d551ec39f6bd22b316116baccd4d27995262c7a789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f588befaf66670b1e9b8e1d551ec39f6bd22b316116baccd4d27995262c7a789"
    sha256 cellar: :any_skip_relocation, sonoma:         "17cab7d12b04a62218ba7da8c686a95c83fc99a2438ff48ad7d86ef8ded1ecf0"
    sha256 cellar: :any_skip_relocation, ventura:        "17cab7d12b04a62218ba7da8c686a95c83fc99a2438ff48ad7d86ef8ded1ecf0"
    sha256 cellar: :any_skip_relocation, monterey:       "17cab7d12b04a62218ba7da8c686a95c83fc99a2438ff48ad7d86ef8ded1ecf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0509c5bbae69359b523816e1e47e5007dc863c749843972fcd76f3cba706af0f"
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