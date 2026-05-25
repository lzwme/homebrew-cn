class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "1ffb58ad4f50f88359299e2e4b3ac0d840cd7ccfb2fb0fdc51b833fa4e972dd4"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d46404fcaf4b949b220abc34e10fbe73477d3dc1bf5c335769666a34bbc840c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88acb08a58e5c965c81fb5844b5dae509276c5d8a7c12794ccc1e63f6cbc4e15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e27ac6d7c13bde9874b50ab8a2defeb64877a913f8ac51d3062c2a16864263fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ba704f8c3ca620b4ba221dd4ff99b52f8fe879ef6257bcacdf0978a390aacc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95ace7c50889a3eb274e6d9741e4fddd3d9ff278d95fe789b7d3d4c11c4f90e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13272a0bfef1318bab46646508175909e40a67546bc0bbe4d72a2e3bdcbad519"
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