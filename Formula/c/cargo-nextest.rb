class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https:nexte.st"
  url "https:github.comnextest-rsnextestarchiverefstagscargo-nextest-0.9.87.tar.gz"
  sha256 "9b1eb08a3d3ce295317ceca65451d244c52b5b705d7ba516795d54c543b07388"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abae22234fa5681f4e9cdab62c172bfc1a93013286d8e3f9e472e7eee85f7831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc2992ef0236d0650a8c792483a38394906592bfa5ec1971d59a4b8291316e7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a30ee2eae0f23b69f207bf58e2ea26f4e9efff53389992e1f99dc5c0f795b81"
    sha256 cellar: :any_skip_relocation, sonoma:        "2605a67a1bd65e251b6529fae23f9708080ce65d12e33b626843f0f158c63246"
    sha256 cellar: :any_skip_relocation, ventura:       "8a73918b577a20fc5fba42c25ea8f5d428054418b10b8bc719c554fc6c4f8fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "460098d5c927447d2df38ff3a96b13aaac55f299ff031c68b0a433016c142f99"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    crate = testpath"demo-crate"
    mkdir crate do
      (crate"srcmain.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end