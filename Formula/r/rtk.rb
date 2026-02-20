class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "f94bb259bfd9dd67e2c4b9bafeefe42ac5995766af8b072296132983b3f28e54"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80bf906ac6f776aca83d72d328b358a5d32479463114b58b2e7e636901b6a8f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de6642f734715b40ea6b5b46f5c5887d23298c2a9e1720f0b85e39fad2b38dca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3dc2e1faad099bc1118e853c0c6075923858ac57f5eff4d02bc9c4b0fdf6e6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "24caba9155fcfaaa0a631902b2e3bd116bb89924a98c2cbaef53d931805f05ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9c5bf5e73dbddbb38eeb35b5edbf7ae36e9ab60a19772634c04997a5fe8735a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2d66c77fd02054544151b855c06f125e0dc0594f5fd6883c08ad4140756d8e7"
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