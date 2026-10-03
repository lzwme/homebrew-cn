class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "01caf19cbfe9d39344197022cd12dec96dced1e623ce1fe6c2d4ed5d596230a4"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "451cb00d85ad3dc110f8faa6c0fb7d754f56b08bad76f7ad9c437c5205d2067c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c767cd2d6a39c29cb494e847bd28f259100333668d661793b94dcb378fd9a8f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb033343e68559ae0690e847bd7c69635f5f1f7c97e18836c8d53e6b3fc4061c"
    sha256 cellar: :any,                 arm64_linux:       "bb50089f90c38f7eba3916ca34a49664367a40b775db2d1ca7aa50f8d7850101"
    sha256 cellar: :any,                 x86_64_linux:      "d1ad802ecc3da68a7fd43d46dcca3a40bf3fd5cfb0fd2412ae7dbb11c35240fb"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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