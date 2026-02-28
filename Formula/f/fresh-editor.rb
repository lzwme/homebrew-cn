class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.10.tar.gz"
  sha256 "25d46e7209ca731d42661b3be68c25e42e4ebff06a156d15ddf5ddaf4a510bc5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d8e15a98ad6104fd714405f6b29bfa27f5961be8eb97c54aadf24c75df37aa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ea7933fc497355aabe07fda89f114a903889e06c96025041f507628d4b306ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6342baf7438f67a2bad7e6d32f3faa46e1cad15e7562f0bc00041e218e7a424f"
    sha256 cellar: :any_skip_relocation, sonoma:        "25f9c27c44d5282dfffbe097a2e027241da5905dcfec9b08dbaf3aa7a332e22c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8074d70295ae339f5b7c6b37b7ed52a567950a9600a59df2b9d0f4f3682306c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0854133848c4dfe4f30dbb417cc752e96284b72af7db80ccd1cefee3e906804"
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