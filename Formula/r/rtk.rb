class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "6ef5147ba2ceecee9aed8f635f741147f26411e482975d9104c4729764563746"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf797dbfe3b68b7be35acd315bd8de5b32b585985eb4644e7db3cadd0127205d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eacde3f72bb409b8f937366610d40ef4ea1a54080332b8733e66de06ee4316d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5215be57be38eca65a520dfc1c7d7f029e6927a9ad62f911cb2f15effa4f1aaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "133d026a999bf103110b02e8dc514ba6d575cd350203f472ef9e8fe4ec4e61b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfd0f42f18b4514a1d0a8fb42c5f3d2a97540f80384f24935a2de0c1d06650b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c926fb2fda30f6484931f4ed5f9df161bf09dc3af8f2daee32bfd34b6d11eb8"
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