class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.3.0.tar.gz"
  sha256 "382f43080d0c8bf1c6307537f8860426cb0039cdb62888626bc5174b59f089d6"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "313f9793fe73e54077fa914a49be0071559d412342a3a990405b40f6b74a3741"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "313f9793fe73e54077fa914a49be0071559d412342a3a990405b40f6b74a3741"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "313f9793fe73e54077fa914a49be0071559d412342a3a990405b40f6b74a3741"
    sha256 cellar: :any_skip_relocation, sonoma:         "85e136ab72bb69fe240955bc7c4d559be2c151927f7ec758f5d70af0295ba5b0"
    sha256 cellar: :any_skip_relocation, ventura:        "85e136ab72bb69fe240955bc7c4d559be2c151927f7ec758f5d70af0295ba5b0"
    sha256 cellar: :any_skip_relocation, monterey:       "982ba2de14bba12b0f4016cf349543bcc7ee06d474bfdefaafbc55deacbacf13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8da34ca44653ef40afe663a38cc62d613e05f3b1075bb46b4887b39d48afac2a"
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