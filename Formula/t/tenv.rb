class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.7.9.tar.gz"
  sha256 "3db3fe06e5ef38aafa0b121d69676829b51cf9eb8a9ea7ec46776c9ed9cb13b8"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7adb03860c365c59e90b4a80e0cd343c2f6d544fb11e9b12188516b1d93101ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7adb03860c365c59e90b4a80e0cd343c2f6d544fb11e9b12188516b1d93101ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7adb03860c365c59e90b4a80e0cd343c2f6d544fb11e9b12188516b1d93101ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "af23a33e31d1c5827c78f5407671eb84c29f65407fca69988fb49a3b629bb74e"
    sha256 cellar: :any_skip_relocation, ventura:        "af23a33e31d1c5827c78f5407671eb84c29f65407fca69988fb49a3b629bb74e"
    sha256 cellar: :any_skip_relocation, monterey:       "0c2d527a7a32fcb703f71b4e210b533676056c015b4e9974e1eba2be97c02786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7287307985e52cc4a93017e68cb1eca6be969b51a9cb6155dbf67171e75ca0c"
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