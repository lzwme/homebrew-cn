class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv2.0.7.tar.gz"
  sha256 "19f71be2a2c99595efe1b559853d887ff3563f1e320cb842d0d523ae1e808624"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41079c6ac3d3006e8bc80f18cf1d79fad0f7c51155a6abf2b480a42db5051600"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41079c6ac3d3006e8bc80f18cf1d79fad0f7c51155a6abf2b480a42db5051600"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41079c6ac3d3006e8bc80f18cf1d79fad0f7c51155a6abf2b480a42db5051600"
    sha256 cellar: :any_skip_relocation, sonoma:         "803889999cee8ade9646be3313aff1ec5db6c6c2dec5873cfa874d2bdc8692d0"
    sha256 cellar: :any_skip_relocation, ventura:        "803889999cee8ade9646be3313aff1ec5db6c6c2dec5873cfa874d2bdc8692d0"
    sha256 cellar: :any_skip_relocation, monterey:       "803889999cee8ade9646be3313aff1ec5db6c6c2dec5873cfa874d2bdc8692d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ea887e5cdd9a59088a46a022a14b502a9b7e6158906c6321c4de2b734b55b33"
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