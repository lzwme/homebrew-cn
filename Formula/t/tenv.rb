class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv3.2.5.tar.gz"
  sha256 "7cd572ecdfa3903fc4f2848872be832144dd3412306c78d8dfeb7a322508bfcc"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a6f80424c0cc0282e2d1b46c4486c5b810b717a0d3b67e85d725d2f7db37e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6f80424c0cc0282e2d1b46c4486c5b810b717a0d3b67e85d725d2f7db37e03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a6f80424c0cc0282e2d1b46c4486c5b810b717a0d3b67e85d725d2f7db37e03"
    sha256 cellar: :any_skip_relocation, sonoma:        "af1334db715e0e094d43198699bb85f595548390e6bf28af9eadc5d158bf0c80"
    sha256 cellar: :any_skip_relocation, ventura:       "af1334db715e0e094d43198699bb85f595548390e6bf28af9eadc5d158bf0c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b8ad9e21b67e41717db47bbe1988d14dcab3e4908bf52666a414a5d736a174"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  # bump bubbletea to 1.1.2 to build with ansi 0.4.0, upstream pr ref, https:github.comtofuutilstenvpull268
  patch do
    url "https:github.comtofuutilstenvcommita5431705ce34bfbe3a12f6b069106025c6fd8cbd.patch?full_index=1"
    sha256 "f727a5ac69a438c76709491f2591f75fec1ceb1f9bde66654746e7d7b413eafa"
  end

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