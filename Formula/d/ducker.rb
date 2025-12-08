class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://ghfast.top/https://github.com/robertpsoane/ducker/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "dda848e20a0c7de266b3f97763293444d1d97ad2a659a97b9bccb4d6722b0d57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25d6ddf628af63f24606ecea7f52612278e0ff0b98ccede7b39900ef3edc0e19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7f61db9c060e9ec8eebefcfe7cddbb1a0c27f7b6f436a8494f1fefe405d1ef0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "babf14dffeee0e06dcaf00c190259e7d2b8e39c97d71f3d9094eabccd4a8d206"
    sha256 cellar: :any_skip_relocation, sonoma:        "be7b44ac6009f4908a6f7bae48fee50b8f6f61c281c81dbfac4531beafe4e4fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8856857f4f25d00925cae8bdf94a7a11415a65fdb2ded6556f4a463aa403b866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a847527a6cec17bad8a51522d6fae9d226700c963398e43a17f564cf351c1a8e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end