class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv3.2.7.tar.gz"
  sha256 "141e8cffdcc27476620da4ac9164ac8d5474d4cb644dc2131e53bd5e8effde51"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "589bcd8c368ee38d59e038fe441b52ce1182463b7f15fb1cbd09ee4860dc82ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "589bcd8c368ee38d59e038fe441b52ce1182463b7f15fb1cbd09ee4860dc82ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "589bcd8c368ee38d59e038fe441b52ce1182463b7f15fb1cbd09ee4860dc82ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "87bcce5e0ef92336a57fe28e839dd749505a6d457fe2ba6b4367bcca2b46568b"
    sha256 cellar: :any_skip_relocation, ventura:       "87bcce5e0ef92336a57fe28e839dd749505a6d457fe2ba6b4367bcca2b46568b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75a2a972d043c8d8e96e0272826cde2e92ad8a0c3f4ea49a989e091ea55b9327"
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