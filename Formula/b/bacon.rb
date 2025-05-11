class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv3.13.0.tar.gz"
  sha256 "016a980181d90f38b7bc2227997a68afd0144c0cf2004dbfdf6dc165147dfcc5"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22465bcf695cb7aadae179165fc3bd3a063b0940d193f30dd61ab65bc9b99ba8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af4bdb76a9b73a75cb3c239e541706a1f89e08e28fa912a9d62998f0d4c861e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fac6bac88b34924e61df7b230863490a8d6e2dd3fe65d649de4632510949ed4"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb3ac0bf72bf3f24195c5ec7d9e1bd336e6a367bc4d8a39e6a3858de91077e19"
    sha256 cellar: :any_skip_relocation, ventura:       "3e06862328aa759b5f85ff1f2f6cb0b62dbdcbaa8f47f14f0e5f5a74b484000f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1e5fa783e642cb874e8acf99d1c757ad220db88739569be5d24a7383a655332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e232a179a601ea7b9e37cacfa2af5286723ed78670aacfc482f4c83da7d50e49"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

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

      system bin"bacon", "--init"
      assert_match "[jobs.check]", (crate"bacon.toml").read
    end

    output = shell_output("#{bin}bacon --version")
    assert_match version.to_s, output
  end
end