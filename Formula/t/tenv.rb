class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.0.2.tar.gz"
  sha256 "a52622abacaf824bcd0e2d4a2e8b15b9b65b24aeae850552c0495741f6b4f03c"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "741b4f1706b3f3c0ac77cb8a0c468f0e58844f8b7c649c64a8dc9eb3fec1011b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "741b4f1706b3f3c0ac77cb8a0c468f0e58844f8b7c649c64a8dc9eb3fec1011b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "741b4f1706b3f3c0ac77cb8a0c468f0e58844f8b7c649c64a8dc9eb3fec1011b"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc2e70733874f81fc8bd4d891601edf6d0e202e45e6560efed5247b60648470b"
    sha256 cellar: :any_skip_relocation, ventura:        "bc2e70733874f81fc8bd4d891601edf6d0e202e45e6560efed5247b60648470b"
    sha256 cellar: :any_skip_relocation, monterey:       "bc2e70733874f81fc8bd4d891601edf6d0e202e45e6560efed5247b60648470b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8481d11c916e31ae8825b222406bdd8fccf1b68111116dba3dc73c9e05001039"
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