class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "735623ee670483216bc5fe7ca0885f1f1358d8f9facf22782a6ea8e8a44f3b3a"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44c235e00c6e7f5358f1d54db1b3b85c69ffe3792db24faa35ab4fe3fb0abf60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41be3436489997511c534b2c9bea5526c867c8724abf4a05fac5e0052c46d034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb581adf4e990a5fc298893797073efc2a74fdcd9fcec53d2979e464145de7d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e7bc3d1e2264ddb2b03692dcab158e04b1b3118d99a8fef783aa1b973e29d61"
    sha256 cellar: :any,                 arm64_linux:   "08a1e1f8899ab7df7bab58fd8b4b449316d4d6c6ff9daef28516b2b97de2e0ba"
    sha256 cellar: :any,                 x86_64_linux:  "ad52d5027a4d8d1452064c6648f93dc3eaf085b3b3166bf6c8137dd2faa23abd"
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