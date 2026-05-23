class LeafMd < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://ghfast.top/https://github.com/RivoLink/leaf/archive/refs/tags/1.22.3.tar.gz"
  sha256 "261ed18b61c0bf725204e4bcfac431431b6c6b1dd8d9845e790499ee2c3609d5"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10aeb192489ad66899f3e441ec0a997b268445fbde4151866dd622381b747b08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22366ba78a121b163b1f2f6846291943fc91cb98fb3d5c99f49a293daa6c24bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b4d1b1cc549857f10e4d1f8eb08372c8f3d5c8755b5f6d55c99f7fa5e9db323"
    sha256 cellar: :any_skip_relocation, sonoma:        "45b3a403ce8c6af1963a81d7f552925634becb9f7416ac58d308c1f317de509a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "108005931b4f23e439eed5ad8a8a3e605768c00240b08d50c7b2607c633a3008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ef1134644373a1d811c027035195a39d1f160231160f99e0f18f887f267c22d"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end