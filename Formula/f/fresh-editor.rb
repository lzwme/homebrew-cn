class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "1a37647cdebae3b98267d6f03ee9678108557dfb65cd5e98e623605ec6b05eb1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b355045a9c3cb09074c905ec0af7b56b611dfc3f099f0648ebd52f0cb5f89c8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37fd469036aded81d29da46f193fc974436d922c7a396ddb53ea7145db11c4d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02219af32d6b6017130ae9cd84084adf61dce53e65d7c3eac79c4dae758a9284"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6cd8231fda2c245b51017917bf67aba51da4492ca964d5009f05ea1320d7964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfa40959a4547b78f519f79028a40b4b2b28c8ec10a3895a26c60f681e588d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "929bd670f68c426245222d8bbbd5d29a76fdb5412d796a25d9321d5d2fabec41"
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