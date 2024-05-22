class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv1.11.2.tar.gz"
  sha256 "99e129b29325716cf2ac8a8dc53591d783a90fcdffae488920a97a834c203601"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af45e9749a2309cb80347ef84a9dfc40c8ef59d5229e5694b190111a3e7aed09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af45e9749a2309cb80347ef84a9dfc40c8ef59d5229e5694b190111a3e7aed09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af45e9749a2309cb80347ef84a9dfc40c8ef59d5229e5694b190111a3e7aed09"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f77231d7d946729536f2234fdf6f8b6e49d2111a519beb01300f6c76a802e67"
    sha256 cellar: :any_skip_relocation, ventura:        "6f77231d7d946729536f2234fdf6f8b6e49d2111a519beb01300f6c76a802e67"
    sha256 cellar: :any_skip_relocation, monterey:       "6f77231d7d946729536f2234fdf6f8b6e49d2111a519beb01300f6c76a802e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00a5c31743ce7d4f53ec395cc0acd7f2e0a3e270e220d3130e6cbbc581936feb"
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