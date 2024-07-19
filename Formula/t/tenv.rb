class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.6.1.tar.gz"
  sha256 "b88cb52d56fd2142b0eb1e2578e36e6b9472665247ba636cfff33ab019242dd1"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6eb6746f287fc4a79d145df236b7ffa584ab8c4578c34699aa1a8b68d3719198"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eb6746f287fc4a79d145df236b7ffa584ab8c4578c34699aa1a8b68d3719198"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eb6746f287fc4a79d145df236b7ffa584ab8c4578c34699aa1a8b68d3719198"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e3701d62631b4f7c4d0530fd05215fab86ab969d755117516a25105daa6e442"
    sha256 cellar: :any_skip_relocation, ventura:        "6e3701d62631b4f7c4d0530fd05215fab86ab969d755117516a25105daa6e442"
    sha256 cellar: :any_skip_relocation, monterey:       "6e3701d62631b4f7c4d0530fd05215fab86ab969d755117516a25105daa6e442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54f19da0efcf8c83c2889d6ca3c6b859025a94628e457552fd5e71d7ab3b9f39"
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