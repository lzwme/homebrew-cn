class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "4711db9ae333bd2555003fb8ca292399d444726fc5c613359c2c6d4e71601f09"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c004d0fe30c7dc1aed2801ce0f831303281e883c57ab028e313b9e28f70965a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72fd7bcea1110efdd9e66ad6437fcfa8df949f62ae9cc747fcee3aec90933ae7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f974b1ea9fe408a38f9212758126a5e45efb899bd2a4b0e66971da478fffd053"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2355453a6f1c62844cd51f2e34370796decb126cf72198227e7c086d51b3a38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "345069b4347c52d78c6e8f5d49cc99d5dea35f3d7ea7b26e107feadc53d19022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cffa1c4e9655f341674d73da63f57fdac24651b55bb001afa69b3ba9c55a2a94"
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