class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv3.2.11.tar.gz"
  sha256 "fb34494b454480c9a4eddc2c7751422e0904a32832a5525bd55abc2259160473"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14e65cfe6d469486b6423bdbbb224283fa5f51e8859b3db4d5d9d8fb53085ad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14e65cfe6d469486b6423bdbbb224283fa5f51e8859b3db4d5d9d8fb53085ad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14e65cfe6d469486b6423bdbbb224283fa5f51e8859b3db4d5d9d8fb53085ad0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e4baa396a2b852f340292d3dc49c933c7257ccb95173670abc399785a8e0d95"
    sha256 cellar: :any_skip_relocation, ventura:       "6e4baa396a2b852f340292d3dc49c933c7257ccb95173670abc399785a8e0d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0191ad4dde884f6e5ea4a504a47af95df659b1468a44220d1218947be1d1681d"
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