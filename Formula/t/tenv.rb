class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.7.8.tar.gz"
  sha256 "0e8b8b165a7a3679010b7676a26fa6c902016acb3105ca13945c9c7aec4faef6"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bf1dbc97436068edf18e99710ffd1c3787016b75ed428cb5628d061fe3b1f11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bf1dbc97436068edf18e99710ffd1c3787016b75ed428cb5628d061fe3b1f11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bf1dbc97436068edf18e99710ffd1c3787016b75ed428cb5628d061fe3b1f11"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdf85e58371f891f907a267eb494ed208c661d413b82e19d0cec6285e1040a0f"
    sha256 cellar: :any_skip_relocation, ventura:        "cdf85e58371f891f907a267eb494ed208c661d413b82e19d0cec6285e1040a0f"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf85e58371f891f907a267eb494ed208c661d413b82e19d0cec6285e1040a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "999deffdeb9accafc6c8abd7fc9517fa08c73bbd6c6513c511ded5da6563f9cf"
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