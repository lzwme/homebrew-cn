class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://ghfast.top/https://github.com/microsoft/tgrep/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "7849853d8be9a47b385a7c1dc33414bb21f7046f4b8fd7fad37db0d46f40be67"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea7421590f2f0321d2bb4c774cec503ac9f4c546e12073f25fce1dc9dcfe606d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d6ad7841fb7256431e409d0af31a01a6beef623ce2c1b717caee1b97ca71d14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d47079204e9b67808c22506c887f3dfcfec6d009d6c7e487ca4b14900fc5ae09"
    sha256 cellar: :any,                 arm64_linux:       "ed2d159da59b2769c3d90c87a37f60b7df495d031fbcfe2dc3c0c69d78146014"
    sha256 cellar: :any,                 x86_64_linux:      "25491669de336b9abb6522966afd842b02acc7025c72832ea4d9dc17466b2418"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tgrep-cli")
  end

  test do
    (testpath/"src").mkpath
    (testpath/"src/main.rs").write <<~RUST
      fn main() {
          println!("hello trigram");
      }
    RUST
    (testpath/"src/lib.rs").write <<~RUST
      pub fn helper() -> u32 { 42 }
    RUST
    (testpath/"notes.txt").write "nothing to see here\n"

    system bin/"tgrep", "index", testpath

    matches = shell_output("#{bin}/tgrep 'hello trigram' #{testpath}")
    assert_match "src/main.rs", matches
    assert_match "hello trigram", matches

    assert_match version.to_s, shell_output("#{bin}/tgrep --version")
  end
end