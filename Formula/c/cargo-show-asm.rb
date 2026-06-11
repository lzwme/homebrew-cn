class CargoShowAsm < Formula
  desc "Show assembly, LLVM-IR, MIR, and WASM generated for Rust code"
  homepage "https://github.com/pacak/cargo-show-asm"
  url "https://ghfast.top/https://github.com/pacak/cargo-show-asm/archive/refs/tags/0.2.61.tar.gz"
  sha256 "caa5d9fa7b7b67a42d23a67d8312dfee5aa7a7e89735a3ac229ad2ea1bb7c62b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/pacak/cargo-show-asm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acabbcfbf101fb872e4d25231f6a40b8c71ce3106fe28ff194929737d59d4ab2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b68d7b7a2b8a658a41eaaa706f0281fdbe3267dbfdf388454ea9cf04a084fb75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df31a81279f3364a73cd4b87a34142505f204ee6bc6b203f66d346fad6dcce05"
    sha256 cellar: :any_skip_relocation, sonoma:        "d00698e175be894c9f2a50d75e1996252ecafbd4ebdca014aeb8a67bcc963997"
    sha256 cellar: :any,                 arm64_linux:   "325815a7c39baa0cf4e5ba9c7d3a146409129a71f4587d5d329746b8325b7f96"
    sha256 cellar: :any,                 x86_64_linux:  "7d3a6761b5cac90744931fe4da327d2a0afe369142ce4a49b027f8480e4ca94d"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "cargo", "new", "test_asm", "--lib"
    cd "test_asm" do
      rm testpath/"test_asm/src/lib.rs"
      (testpath/"test_asm/src/lib.rs").write <<~RUST
        #[inline(never)]
        pub fn hello() -> &'static str {
            "Hello"
        }
      RUST
      output = shell_output("#{bin}/cargo-asm asm --lib hello 2>&1")
      assert_match "test_asm::hello", output
    end
  end
end