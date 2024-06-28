class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.2.1.tar.gz"
  sha256 "6dd576f86244f982f005e08c00c025db6b44c7da889be0cb7a6fbd18a841d900"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75da63fc99d352b84fb4ace2cab619432f8d994c55bf441d3f65a96002191da5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75da63fc99d352b84fb4ace2cab619432f8d994c55bf441d3f65a96002191da5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75da63fc99d352b84fb4ace2cab619432f8d994c55bf441d3f65a96002191da5"
    sha256 cellar: :any_skip_relocation, sonoma:         "40086e2b75688628bacdfa9bccd7ae1b6659e90b70b33b4f0043e26fca9b68ca"
    sha256 cellar: :any_skip_relocation, ventura:        "40086e2b75688628bacdfa9bccd7ae1b6659e90b70b33b4f0043e26fca9b68ca"
    sha256 cellar: :any_skip_relocation, monterey:       "40086e2b75688628bacdfa9bccd7ae1b6659e90b70b33b4f0043e26fca9b68ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05f0966d628ca64705849eb053e9c8fdf6908a4bea62370124a508a8ecbd19ab"
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