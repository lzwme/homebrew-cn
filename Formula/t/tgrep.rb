class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://ghfast.top/https://github.com/microsoft/tgrep/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "a60a4ef0afedf996c3f2bb55faac7fdaebda710e8a2c7cbcca0d90095d4e0030"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2355e020efe4c63de698c6d5f50cdbd74edf5e154c9652bebee00cc714dbc79"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6a6ee281e0c6f59ae550f1bcae7a4a48566ff6e8e948f4e61a5a2ca782e9381"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd7ea50923c125552f4ce8a6c8f6d24be63520bc30c3832cf975ff5ee6ac9427"
    sha256 cellar: :any,                 arm64_linux:       "63fc3489e36db8f2eb0360af34b8a539c4e9a2b665f9582e4e47828047d4bfd2"
    sha256 cellar: :any,                 x86_64_linux:      "b0bf527e041d44cf95a376fad50ddcecc205ad47f082106949b84490cc67ea17"
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