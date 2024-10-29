class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv3.2.9.tar.gz"
  sha256 "0a0cbf6b7bd9674750e6f5619698d1bf0a82841bb514ffdf5ed648ce5f11b594"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c5e71b3a03b6fd8256515655f53ff69630230c45999d8887cc2b16e530e395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3c5e71b3a03b6fd8256515655f53ff69630230c45999d8887cc2b16e530e395"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3c5e71b3a03b6fd8256515655f53ff69630230c45999d8887cc2b16e530e395"
    sha256 cellar: :any_skip_relocation, sonoma:        "dae4db875068229b5d27f1c9cd51484df34f2cda25769b65d380ad77737b9de1"
    sha256 cellar: :any_skip_relocation, ventura:       "dae4db875068229b5d27f1c9cd51484df34f2cda25769b65d380ad77737b9de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddf9652dcbbb396f804d31635e56adddc16719e661405c5551241ff68bf59a15"
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