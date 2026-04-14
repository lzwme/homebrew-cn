class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "404c304a481f0090f72a7c519380bb0a6b9e233b7221f821050cb21b25b926ef"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8e32099aa2ba3be111eb80050975313409cbb571ac467a3c44e9a7e6c005138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b09759da672d33a49799ddf4744140acdfc7ac0a55a565203ade38692f12289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da1c850ac37cc1282e649ac8537f63e15750220c434307892147b72756e4a05e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b32b5add7ada4f5e1ca8f95a95d389b890d3b18534dbd233ee0c7ae6b551a327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23783acfd57aa4502d94cc5b24456f386a2cae417b4e44accc4600267a18a75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2568ca1f3db909b11c67c3fd0bcc9f0d64cb389fa712685bceca6ee885d17244"
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