class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "c742f292db877de400a16e92528fbba6efb4be43967c4d84c3a488327467a0ca"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b546dd3506398745fc4ac8281ea62f48b2e11b657ffe1638608f39ed6ac1ee3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f85829d928f9625ef8694659ea2d105e7dbb9ea30311ff00077e3779998acbc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b10c438f9252bbb607a71794c7cd1b3be18e7f60bf2e2b91973f7249ab61be9"
    sha256 cellar: :any_skip_relocation, sonoma:        "627d3cc7be11d783d4f675f054ed1e5caf420450b3f16546dbf8d0943c647edf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb7144919d5fa06715cc1888b75624056ab8ce1cd327ffd26d37645f947db5b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83c3393176ca77d9cccdc8f192e9b2d1ed5b1fabba4f788ea5ef6a1eb5cfc88a"
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