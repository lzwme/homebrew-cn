class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "76b9731fe75b3a2d3e39acc695c7fa16b74c7aff4744f6afcc5cf2c9b529ed60"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e1bcb9ea6349ee5f235226d7d50c3e4436ee94e6e216df27b78cc3c655a778d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56248689dee0622936ad7188e0a36eb618c3da9b1728a4439f035f750222b4d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f0ca97f321ae612b8ed1bd36ac7dfce004de6893ad97a09fb80e23821be53b9"
    sha256 cellar: :any,                 arm64_linux:       "e22259ef4a3df8c443774c3aaa36f2f87d66a1ed238055671e8ddd4139eb42a7"
    sha256 cellar: :any,                 x86_64_linux:      "83ecdcf5dab03172c010f1dd4c2856648d5fefe2475c3eada0f9c32b5973c4a5"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end