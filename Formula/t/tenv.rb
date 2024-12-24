class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv4.0.3.tar.gz"
  sha256 "ad21d996331e3aef325769f18ff08d729cf635e277bd3780ed6cd49c89480e54"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "248bd6e8a40a030e7fa3ba637fca15092e3cbec248aef73b900a1508a28bb9c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "248bd6e8a40a030e7fa3ba637fca15092e3cbec248aef73b900a1508a28bb9c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "248bd6e8a40a030e7fa3ba637fca15092e3cbec248aef73b900a1508a28bb9c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "35d9e5216c48ee179ff33faf24e86907fb520626a5c45f561bcbbbf73b847f9c"
    sha256 cellar: :any_skip_relocation, ventura:       "35d9e5216c48ee179ff33faf24e86907fb520626a5c45f561bcbbbf73b847f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f47ab09d2a6125d4454f7e2cb3f3af3607ad234d914292372e5cb186fadc9a1"
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