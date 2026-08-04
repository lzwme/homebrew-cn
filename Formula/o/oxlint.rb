class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.77.0.tar.gz"
  sha256 "10e2ea33722812451ae129a7a6e77c781439412843555144e2ce1c91c17a045f"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1accfb940a1479b525b9576528f8f8657f09f475af48fe667c063074d5d73116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c164a6fb72bc5a51dee3d0bec4d1f6150b412edae51721cdc95e5ef18490037e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d85d6311eca2a0f8f19592e1d598be869c508b8a112f03d618ef5e3abe153294"
    sha256 cellar: :any_skip_relocation, sonoma:        "249c2efdd8b3ed4885fe6b0b43c1ba39ee9a5e2b6bb3867048c1f6dfdd0134af"
    sha256 cellar: :any,                 arm64_linux:   "846bfe602e0f42c75de18cc4674fd9bc9da3ee4da8ce78aa541d9f22af312077"
    sha256 cellar: :any,                 x86_64_linux:  "5d75527326a31d7d61024d7e2916d121605d26df31534870a7eed02e7dcad0c5"
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