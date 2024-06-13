class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.0.5.tar.gz"
  sha256 "4ff35c9c2eaf066f73424eaba0ef20a615d2a74e09c7a781e1dbc6a51f32aa4b"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53f0e7ee764f5b52a369d75ec3419ac04dea097fa4668afa544601a604fc2f00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53f0e7ee764f5b52a369d75ec3419ac04dea097fa4668afa544601a604fc2f00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53f0e7ee764f5b52a369d75ec3419ac04dea097fa4668afa544601a604fc2f00"
    sha256 cellar: :any_skip_relocation, sonoma:         "7db86b18d3938fdf8a239b64a2dc2da74e3f9f4931f74878b29a70d42b5fb315"
    sha256 cellar: :any_skip_relocation, ventura:        "7db86b18d3938fdf8a239b64a2dc2da74e3f9f4931f74878b29a70d42b5fb315"
    sha256 cellar: :any_skip_relocation, monterey:       "7db86b18d3938fdf8a239b64a2dc2da74e3f9f4931f74878b29a70d42b5fb315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e83e025be8871810c44e094f8475d38eaf211304e643a05357bd88b048bceef2"
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