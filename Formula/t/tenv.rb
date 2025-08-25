class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://ghfast.top/https://github.com/tofuutils/tenv/archive/refs/tags/v4.7.19.tar.gz"
  sha256 "cd0f3ab0690c820eae994c2fb46bf4ad1b297bb47ac7fd8a6e006ef97f407e9c"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc12b9c6383134094f0f09ad6c3addd3b1f7319efeeef6f54803d97af61009ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc12b9c6383134094f0f09ad6c3addd3b1f7319efeeef6f54803d97af61009ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc12b9c6383134094f0f09ad6c3addd3b1f7319efeeef6f54803d97af61009ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c8d430d1d8ab60f4ac2bdd94d04e0118020f447fc2220730e3d3853aed7f575"
    sha256 cellar: :any_skip_relocation, ventura:       "1c8d430d1d8ab60f4ac2bdd94d04e0118020f447fc2220730e3d3853aed7f575"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fb02d9744071d812539aca7977584719978767e31b58281f46e005203dcb525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4687fd7c1ca72d8bcee9ac889e9da6b245cce9e26bcb901729790102b9971b0d"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "terramate", because: "both install terramate binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt terramate tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end