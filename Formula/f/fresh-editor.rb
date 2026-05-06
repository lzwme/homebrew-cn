class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "39b3a5c3cfe2dd6af7e2d202faa33275d71796826fa9b9590daaf96558585691"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b91e2d583fb2b0f9cc6dfbd9b429a39658448d8a67d30f06b354bbcea3a306c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8135de3227d529b03ccf4ee3047cf0fa3e1de0a68306bb37bc4284ed8f935f87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5610b8e5585029a0cd1075091b7b427f159d865a1cdb1eb898646252518539ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "73967654c0f0d239ee00965f6e8743d32c7678fa9c1a63216137d1a3e3548a65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4437a82f52af581a8ae98050476924cb8e1440dbd666088d2a6c6023b251f324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f347225fc34cebded16340369798d66a3ca3813c4c2380240c5fb777c7ae62"
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