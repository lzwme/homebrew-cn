class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.6.0.tar.gz"
  sha256 "2d579d05d89fde9b2b8b4cf1b60d7604353455d66807c7f93eeff8d8584184f8"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73828a43beb5daf1310640bfdaaf440c92926e9fc2005f089234e1ced9aeae71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73828a43beb5daf1310640bfdaaf440c92926e9fc2005f089234e1ced9aeae71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73828a43beb5daf1310640bfdaaf440c92926e9fc2005f089234e1ced9aeae71"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf8cd747b9d92709591ae131cf87d6d9637dce7efffbcd4707425e338ef5d191"
    sha256 cellar: :any_skip_relocation, ventura:        "cf8cd747b9d92709591ae131cf87d6d9637dce7efffbcd4707425e338ef5d191"
    sha256 cellar: :any_skip_relocation, monterey:       "cf8cd747b9d92709591ae131cf87d6d9637dce7efffbcd4707425e338ef5d191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d935327c6f672e18be59cfcf0ee2e57ca5c812a4108102fd4325ab836985d490"
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