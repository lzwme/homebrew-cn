class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "8358aabad38a7d4a8e00732c17e796651469090bcc4e096f7d8883331b2e6e9e"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "179c988f91eef3cc648ffc0d346769595a46673fcf34e645521a310722800351"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e12513d1768c81a9aa72af8ea77e244a922a206d35dafd2689817317829a1daa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfeb6c0eff1d9c16ad5338c22cd53a419b795ccc8f0fc5bf6fd6f87a50161219"
    sha256 cellar: :any_skip_relocation, sonoma:        "be836d25c822358b5c3bcc4b6a1931a264f4fe055dc9a06a9e76812d9ca0ead9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb538d09cdd8bd0fb53b63b349edbb993d01683663624ebb03f54234fb625613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e1f40399d5dffcadf86d7b0545f60472ce3f0c8ad51345dff25b69d61f0d4d4"
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