class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "52fe3372310ef37e9ceb495d1b5b8d8401765fdda6e0c656f832316baae0c8b5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fa7dc245a8ba81fd7d0b7b34855c718b751c640e6b4a0e365f3502547c9c84f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8465c4b9c38067494d54f6a77d1083c52d14d4cbcaf22240175e8a0e7934166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d2487cc4cae011d328d9f6481acfc706953e3a8f90bad1a431303bc50025bef"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fb520439d388a9f2badb19f76c8997cac877ebeb363669caf77e2677a30691e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53e313a4ecace34932e7ba077cd348290830f23d01c036cf233d1260a04ab7ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "300b852ed2de3fa8813453a210ea27aa451f6766fa24f3b09753aefd8525ab79"
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