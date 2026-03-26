class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "dacc7000c53fd68fa8d5e0bf998d81172b32b81e106fca5e8c71cfc895bd9374"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cc285af4caebd66cec5936341f6df6a54240dbb3f0f566e5ee16978a8c979f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c35277df6bf14ac1bb0a6e02f88896f39547380a1f840e50888173fbd4e4156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e29ff1d86fcb9c05ca2a63fc6e0f5bcc5ca51ec58c21f42bd4ab3f5e561ce15b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c47c54699319abca1cab6d937bab662b9272127dc3b583d1b476225598d9ec45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb3441515734cd51ebd7681756c94fb93607e99c917ab25b24b104fb55831643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ab6d70ee4c6cff4d10f91e607a7f7d02b9857beca1c17a501c0f944802e36f0"
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