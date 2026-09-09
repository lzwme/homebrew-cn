class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://ghfast.top/https://github.com/microsoft/tgrep/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "b4c8969cd15890bb0bcab86fc2170c259411cc5a9c107752758140839f2f577d"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20f72168076b154ee78a6b8ee692c62c353daa93ab3827610016c66592338e31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be98b501d9936f7488ac0805f09fc2eaf3dbc2c9478df94e7d635ad3ea61fd22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2004a303c06dbc4df598d1ec6060a4d0f8cfa009ff00e6ac4d731487fb5cc095"
    sha256 cellar: :any,                 arm64_linux:   "865b966dd1229b15a8bd8b635640a543da4b4c865c42c0cb6a93241291db3234"
    sha256 cellar: :any,                 x86_64_linux:  "9995304819ecce1144dd6d4372eff3ec59ed37ded8e8b503ff9f406acf3e2059"
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