class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.82.0.tar.gz"
  sha256 "cc6d4f6e27c3a420a4a22f25fef4740099c111515334cacae02e6a7d24b707d2"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "569e98134694b1ffebdefc37ee2a2301e0412541ae2077d5aedbe5f22bfc9430"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b32bb55f60b1a2f79a4f8057cf8f6a642f83ef3b8c4e068b63dc85383da8f8cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4bd0c6defdc1bbfc6936afa707c60ad8f973d3e10477295285a995119c550ac1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "953b52928203c7aed08804534307d7156ad84c18a9c21bc58d002a6bda6a4def"
    sha256 cellar: :any,                 arm64_linux:       "c3d70c6e6937b21aead7caf11c5304f5d1c94ef690b43e5e9d67ef59ef52705a"
    sha256 cellar: :any,                 x86_64_linux:      "753e7fe3e7ac870ad3997f34d36e51f31bfab59a641547d6d4f6f7ca4d5003ef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end