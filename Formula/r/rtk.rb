class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "625f016f5c4db7677c0a99dea8ed233c8f7e619759340ac21f6e357d502e5bfe"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66eab770462cd9359861cb027777c35f404596389600a43ecb96970404ec9178"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1161efd54238c2efb76f6cf4d08d245d6cb6e65fb768109003abebb20b7a1e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c0f4cdf4a4e91f7c7b894f5fa5c5593536aba9e659a9ef9d432cdb140f32921"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dfdd304fd2264b14f6b4c133df2f6be2cee80ab8502cd4c1bb0124d7671b433"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f069d75cc74028e60fd9d5f8ca71257f3b9fe9b141b6787d36f8ddf4d100c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e19b0ab045b6ef27e779bc7345b1cd6c505795049d0da462c1624fd03a8ce1e"
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