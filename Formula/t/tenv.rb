class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv4.2.4.tar.gz"
  sha256 "b7a35bbdb959df5aec61c0ebd7c6e5958be6d3eb04720d57e8f3a22026168dc9"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4d791c05954cbcbfc36c7e8a72ef2d517af7b45d93ae3d3a62405a3fc8c9301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4d791c05954cbcbfc36c7e8a72ef2d517af7b45d93ae3d3a62405a3fc8c9301"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4d791c05954cbcbfc36c7e8a72ef2d517af7b45d93ae3d3a62405a3fc8c9301"
    sha256 cellar: :any_skip_relocation, sonoma:        "4185be574e6693737c97d3d84e7fd6ca4716913e3697d26288be8ca86050b7fe"
    sha256 cellar: :any_skip_relocation, ventura:       "4185be574e6693737c97d3d84e7fd6ca4716913e3697d26288be8ca86050b7fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17a6fdd9087207883b78549083cac8f924eb5474da043e863c4790e63250943c"
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