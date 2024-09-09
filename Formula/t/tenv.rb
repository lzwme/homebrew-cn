class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv3.2.1.tar.gz"
  sha256 "cdfc0af218089aa1466a5ccaaba2d4510d09137b75ba0aca5573523ac1fd32f9"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "559de9f757bafaa7eb2b015356e7b5abdb5d5b1e50569b10290fcaafd047a16d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "559de9f757bafaa7eb2b015356e7b5abdb5d5b1e50569b10290fcaafd047a16d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "559de9f757bafaa7eb2b015356e7b5abdb5d5b1e50569b10290fcaafd047a16d"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbcfb1a2f9faffc03eb2f1779a8427ffd0459a06bb3f1ce72f8eb4540cba986b"
    sha256 cellar: :any_skip_relocation, ventura:        "dbcfb1a2f9faffc03eb2f1779a8427ffd0459a06bb3f1ce72f8eb4540cba986b"
    sha256 cellar: :any_skip_relocation, monterey:       "dbcfb1a2f9faffc03eb2f1779a8427ffd0459a06bb3f1ce72f8eb4540cba986b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9983d08f9f74343f1d44d520d5ab087f3d3080a046a0dce4179ed644b0d68f5e"
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