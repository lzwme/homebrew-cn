class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.4.0.tar.gz"
  sha256 "3a02fa79ba0b10e8f18b25c27dc4f6188806b2d608e4c5fdfb98231df465cfd8"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43e207089b0e065c839e327b64a3069fd16499bada5c82db40e581abd8cb97cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43e207089b0e065c839e327b64a3069fd16499bada5c82db40e581abd8cb97cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43e207089b0e065c839e327b64a3069fd16499bada5c82db40e581abd8cb97cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4534f62104d47c76e7b0cd2c319bdf0ad3886120bee8c747e526d6289d8e51f"
    sha256 cellar: :any_skip_relocation, ventura:        "d4534f62104d47c76e7b0cd2c319bdf0ad3886120bee8c747e526d6289d8e51f"
    sha256 cellar: :any_skip_relocation, monterey:       "d4534f62104d47c76e7b0cd2c319bdf0ad3886120bee8c747e526d6289d8e51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b336efccf4ebc0f77d750cad81f0e094c8082fe3db11b9f04a1aef267f7597ef"
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