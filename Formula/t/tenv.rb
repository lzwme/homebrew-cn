class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://ghfast.top/https://github.com/tofuutils/tenv/archive/refs/tags/v4.12.0.tar.gz"
  sha256 "df3456d0a0f6b8c0c705d79af41de588c641ee14809e6fb9a3e77001c2c9d6c1"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dac6a1036574e636c68de86f7fe6943b58a718dc8cd245d4e6915ca00f877ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dac6a1036574e636c68de86f7fe6943b58a718dc8cd245d4e6915ca00f877ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dac6a1036574e636c68de86f7fe6943b58a718dc8cd245d4e6915ca00f877ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "b09f4219edac673738b0b1ffe9ec679af04bba0ca6d35efd3db77b77179ff664"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3673b676c5f078a09c9cfb092be898c0cd1d049a385b2b7aaaf613eb626fd5bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b864927a4f68b7f7f8f43581e0cb9cf8bfa73a614dfacbff2595b7c47d74a7ba"
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
    generate_completions_from_executable(bin/"tenv", shell_parameter_format: :cobra)
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end