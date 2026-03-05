class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "d079d7e0927e93c27eb66a08a0ab621c6a9abce6d5978ca5a30c0f715b4fafca"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71f5876e9fa912720d44f81d7eeed22200a15154c560fa1f5030d4f5301847d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a902b6f14d74cd95c7dcf0a264d18a3be607191f75f7b9c71ff201b65292d990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa78bf8da6902480d6e71166b8926308aeba870d5203962ee4cb8319047c8327"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9199906d3414e2b68a984cb15d39ac59fbb6ca5b1d0d68de1723a346edbed77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9007bc05abcca9ab19e57c41f421157fbcd2df31a8709f5dbfb561450ce0769a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5723684e672d0e0559286548681967afd6ece9fa2bb6daf042035e17c91b7b58"
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