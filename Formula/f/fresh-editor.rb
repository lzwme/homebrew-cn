class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "c38bc42152f88e96e557ed26d3d5ba43947e4170760cb85b6b9c72b640e5bf36"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd71ba583a4fdca820c293a5a89b9e83e6e083798938a6c59e84d3177570bd0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1995c4dccecc6984dd2ca86e852ceea0d7cb4094769f4301047992b520ec87d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc6a5ee03d537d0de682a0b6470151f00f5c5f51bb027b7d95c4e6dc891bb8d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "72db90edcff5cb35a16787f14b24ab9d41fa5a56dab3dcaba8639112b335d62d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b3eb95a9faa25668df9eefc4933d4b8989acd966cad5cd3d765a16d819cb838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c01d687b396917bc494c4f09ee5c855e2c32f5274e9427dd64a0d641c08dd27e"
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