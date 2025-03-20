class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https:huacnlee.github.ioautocorrect"
  url "https:github.comhuacnleeautocorrectarchiverefstagsv2.13.2.tar.gz"
  sha256 "48ae3f07ab3f8a1df40f2fe6404ab8dc39b459d566490bac6c4ffb6a91a0d223"
  license "MIT"
  head "https:github.comhuacnleeautocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0111881f2907223f99cab580acf784fa81aac6e602fcb88c137d1c1bb8f5e677"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "845bb12825e5c26e7cedf85c79b28e40b46f665733dfd86ec02e96a68e0e682d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0426632d0442fe3aa6fbc775289ee8f92d68a44d1f6c9a16f595753ffa3e278"
    sha256 cellar: :any_skip_relocation, sonoma:        "74a7bd37368e5ea39b548529129d514adac1a2b9170085408bcdaa3d92cff15d"
    sha256 cellar: :any_skip_relocation, ventura:       "b4a96e184fa36bc2a913fda28fe72b5dd8d0969dccf84996887e9660137495f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e15d33199ae4a07cdf2abcb02179849f91418ed1503118837ecd0974b3e26100"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}autocorrect autocorrect.md").chomp
    assert_match "Hello 世界", out

    assert_match version.to_s, shell_output("#{bin}autocorrect --version")
  end
end