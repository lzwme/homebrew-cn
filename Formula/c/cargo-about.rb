class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https:github.comEmbarkStudioscargo-about"
  url "https:github.comEmbarkStudioscargo-aboutarchiverefstags0.7.0.tar.gz"
  sha256 "baad943a78f25676e4ebfd089b49d3e275f3e015d5633f2c1c274c5ca607eeb9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1527ff661626a2c64e98b0aab9699d1975f03df28e421e52025463d5db0c4b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da02639aebe152b195db07706005d34f25f3c673aa9ae52d71004f8f3e6092a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d35f9f59f6b7bbf0861efeb74765316c7f5688efa739346752613eaa78d8a54"
    sha256 cellar: :any_skip_relocation, sonoma:        "62676d2f53e09af08f0352690b88df57bf37bf2227f949eec558ac403ffae0d1"
    sha256 cellar: :any_skip_relocation, ventura:       "b1639cb3913464ecf224aea35f1577a239af3c4b2ad391b6258e6ddaff5be46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581e4c626e1d74774ea63f4cf1a433270892d1008cf196f14057e43c7efd5719"
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
      assert_path_exists crate"about.hbs"

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