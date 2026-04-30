class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "26d02dff5a315ca3e620ddce36c46ab6b478c060827e06c004b2b40fa8c9ef0e"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a73920a562b5533cccbede5f663651a0211f3893e26ac2ebf62a9ac2b58c88a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47e4554a2488217c0521445b4719c8e599c5bb13491645eebc3caf75700bc03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27052b0498f2ddfaeb39fed3ed70669417a9c50b3da68dd9dd048cc4ea9789db"
    sha256 cellar: :any_skip_relocation, sonoma:        "a402e30af197ea1079b0865b57f1338d87ac7279b37fd1cf6451f5a97c6cf61c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "304953b14ded41fe9a61f43969745d0264a86123d378ae6325c0a17dfc12406e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca1eff2c108fadfffb4734c2a9b2f19cbbeaae5a015f68239a7e32be3ab04807"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end