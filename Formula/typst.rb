class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://github.com/typst/typst"
  url "https://ghproxy.com/https://github.com/typst/typst/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e0bfff4749549ff519be6659b16958eb47f7f39957c0ffd2a74adb7a421d23c6"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a766ace358328cc1590a000e5b6458a4ff2c8dd9c5831f0ade1ae917d41c0b1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "310a0dee41f4f0df63cab2e8d78d7b7d35257b1fb71cb99195a265c9f6af01ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0f89ea63a21fc302a8cd8fe916e41deb7455889cde01427b9ca8c7d5538e622"
    sha256 cellar: :any_skip_relocation, ventura:        "95a6b4f01e105a426e80e496c8dc875177d2310bd202c07cedfbaafab71f4bd4"
    sha256 cellar: :any_skip_relocation, monterey:       "b8a91c1553a4620954400ca7dd78020e9da9645401609b5fe36698d06a8d4c31"
    sha256 cellar: :any_skip_relocation, big_sur:        "e27443db57fbceb6735a0c4da81115227e3af9fd8afad9b6459944385583ea73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3cad27b08626f199598f320741f2b024f0acabbc2c18ced504bcb0b11bd4099"
  end

  depends_on "rust" => :build

  def install
    ENV["TYPST_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_predicate testpath/"Hello.pdf", :exist?

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end