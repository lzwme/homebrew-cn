class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https:github.comEmbarkStudioscargo-about"
  url "https:github.comEmbarkStudioscargo-aboutarchiverefstags0.6.5.tar.gz"
  sha256 "1d789a86b6e73725c464a7c361f45ee1191cb45325ff8d35dbd0d321526715ef"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3555f570afcc466809b6af1a5c14d2af4a0d1ee41329cbe8c07e7aacc77d9bc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "516d773b1bfacf1619a64d626eeb813aa3e115516d4cb926a05e90e1131d5245"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d7e5a254755e8518a435e5905f83444b94fcbc58b59f0bd05b3736fabcec2b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2f587d49ddede5eaf4aa4e8baec7f372f54d875d6cf3aa1889187a92d0db3e9"
    sha256 cellar: :any_skip_relocation, ventura:       "c0ad78de355c73544d659745b1f17cfde57b407c064cdd447f4a238a24c889ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "014be5ce4713a49c6adda9b39c141a9289827f15f3fe92c2f08ebd7a4e0b4501"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
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
        license = "MIT"
      TOML

      system bin"cargo-about", "init"
      assert_predicate crate"about.hbs", :exist?

      expected = <<~EOS
        accepted = [
            "Apache-2.0",
            "MIT",
        ]
      EOS
      assert_equal expected, (crate"about.toml").read

      output = shell_output("cargo about generate about.hbs")
      assert_match "The above copyright notice and this permission notice", output
    end
  end
end