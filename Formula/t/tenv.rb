class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv1.11.8.tar.gz"
  sha256 "03093a23aad4022e36f8b9cf5facc8f7e1a769e94ee6602935d7ff65699b0ad2"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f44da8ca6159556749f09bda320dbc85834b6b3d37cb14e1181c3af2559136bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f44da8ca6159556749f09bda320dbc85834b6b3d37cb14e1181c3af2559136bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f44da8ca6159556749f09bda320dbc85834b6b3d37cb14e1181c3af2559136bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fff725242f811cc8084e3ba54a6800902bef308af453f8be011c8699a5a8ce0"
    sha256 cellar: :any_skip_relocation, ventura:        "8fff725242f811cc8084e3ba54a6800902bef308af453f8be011c8699a5a8ce0"
    sha256 cellar: :any_skip_relocation, monterey:       "365301b35556d2777562673fa16d105cfb093f98fd1810ad80ad9fa2f558140a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6fbf2b89f2d2fd9b3dc31a0bc362b33b563379d47bc07893194635ac2ddbc04"
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