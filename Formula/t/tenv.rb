class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv3.2.3.tar.gz"
  sha256 "c89e42dc8490d8a4a54396829e998c4487d36e57e23fd4a66e6d3778f7b0ee5e"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6b6980f2c7e023a57014c9c4723865c6d33a459d5d3fb4ad7a0ac7494a84e23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6b6980f2c7e023a57014c9c4723865c6d33a459d5d3fb4ad7a0ac7494a84e23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6b6980f2c7e023a57014c9c4723865c6d33a459d5d3fb4ad7a0ac7494a84e23"
    sha256 cellar: :any_skip_relocation, sonoma:        "85536c6f8bec21e0984e0291e4c9bd2d5443284da650b62a530a2b590f2d20b4"
    sha256 cellar: :any_skip_relocation, ventura:       "85536c6f8bec21e0984e0291e4c9bd2d5443284da650b62a530a2b590f2d20b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba2f469ac566d80214896dee69dbbce69376117579318cefe2ed1df5510230c"
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