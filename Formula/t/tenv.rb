class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.2.0.tar.gz"
  sha256 "1593cfb75c96bcb395c4de6c633370d8193be0caa1d7ed05adf7a88bd5a43ad5"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b651f0c71b77c2d05e5809cf1a1603e02b9a47796570249527b895469fe63702"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b651f0c71b77c2d05e5809cf1a1603e02b9a47796570249527b895469fe63702"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b651f0c71b77c2d05e5809cf1a1603e02b9a47796570249527b895469fe63702"
    sha256 cellar: :any_skip_relocation, sonoma:         "c27ad9ce5da0092eb29a9e721a9880f9b0e05d7c59d3c9fd27037ce3c812c25a"
    sha256 cellar: :any_skip_relocation, ventura:        "c27ad9ce5da0092eb29a9e721a9880f9b0e05d7c59d3c9fd27037ce3c812c25a"
    sha256 cellar: :any_skip_relocation, monterey:       "c27ad9ce5da0092eb29a9e721a9880f9b0e05d7c59d3c9fd27037ce3c812c25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c8dc576cea69368e5ea81cf543d69e57312064e51c276d99991489b907dfa1"
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