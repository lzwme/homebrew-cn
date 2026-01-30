class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.97.tar.gz"
  sha256 "05a0cf66b445cb43b063f235e08e106391b8cb5fdce44cc50cddceeae5e8c29b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8b8eeb34db43c4af8bf0d9bc34cc5ad76e9074b8966a6d93f3de5117455a29c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cef3a7a333d9bf45f18b2d7a6a074a55671752988c99658cfb6d43a917466282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3487054cdcd5e5f9b4dfb62fea25b31624f02a9038f193ad3ab248c6b5fffa47"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dd56988330afe2e04c089738a873e6e6350be29e9674730d451d1d024173a39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5896b719bb66564e18f5d340afd604a4998695823d2bff05d140896df015c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb2da966f21a85ede8b723badb0bc1b8367962756194805a34cdef9fa9bec51"
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