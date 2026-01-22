class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.87.tar.gz"
  sha256 "5e0619f37e27bd25286407dc3037ad150508f71cb58333d26d5a6aa51c3ea68a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "686f6e0a9e901bc3d776c405e2312f482f47b9d5d372b1d067bfde70f31a0e29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c28990d16ead54780846aba8faec536bbad65908bbc378b0a5a849d6497b88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33ca09d373913db09d05bba68fc20f36bc42ffbdd61473d24aabeeceb3c876d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ced9218d2c2c42f9449cae01153850267e3b8b64380418fa3e8476c6a04f15ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1954c695d47750185931114f05b048c9e3905bd4fabfb790046caa67115a5943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56eba8b80940ba90d9f36f1d235dad4ab3a467a7390d64bae72ea0f54a156c52"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end