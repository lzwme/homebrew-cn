class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "b314ad0f7498aba843706cfaf2b474cbd7697ed06854813fe6151ca41b17c946"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6edcdaf016b704c283a7d2879937133ea83ab2a5e0150cff3804db179f64930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2adc4f4fcc8b1665044ea959231c8a5931316a58f2c452f42ac6c09f83a35c69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1ef2ac0b81a7a72dc0f1fdf057ed193db7c04b56d9de49b8c89b86d702b3c67"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c219590523f16ca1ef1c81da5f24d9eb453583dcb40403d35a11e7087142d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f522440bd0d9ddff13aee47fe1054f346e7da5d1d34cce2df7a663fe36edf58a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d14def7a72db49ebe280b42dd00803b42a5f4fed2eba6ff991988b86f4b52fb2"
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