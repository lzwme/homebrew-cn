class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "38d06554b8c825750c34ba273824590dfcb23861921b55dbd509b6efca81896e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2a56a5681de808e378fe0c9ed08881ae28e228b69f2e3517a60e662b2227b57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "939715c3a4788407275a7ea9b7d70f497b5f406076ee9ebca4011202d0e21624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8bd7fde041dda72545072efa58c1558738a65bc77d818bbde6290d351ae363f"
    sha256 cellar: :any_skip_relocation, sonoma:        "72b62402e73a62c0b6cca64b89c132152ff66fc68c1cb335e84dfe206b10e016"
    sha256 cellar: :any,                 arm64_linux:   "a453b1068ea265f1a2d52bab5f6dd1a759d9f791525c4b9e1e42b35b2138d3f6"
    sha256 cellar: :any,                 x86_64_linux:  "dea701898644faf25bde28054dceaef785f24af2e98cdba986d5cd73a87943bd"
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