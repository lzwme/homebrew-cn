class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv3.10.0.tar.gz"
  sha256 "12f7bf631cccd1fb847741d0a2841fd6bda6b4fe6f650bde34fd47d94bfe88ca"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7fa11ac7f6da7a0b4b376c1a46fce9e73c3291737dd1748b47b1f566c3cc59c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86a42fbb092c8f40545cf3ad298eff2786ed9f95f1ad74f7c1f54fb303623760"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0092023b2aebc15c8bdef6ae998eb0775bed88e6401fe663b38d3bbbe211296a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbbb78993c1301e3027a58e93ac0b8cb697c24704fc38a2a9f79dfabc0bc46fc"
    sha256 cellar: :any_skip_relocation, ventura:       "ef49b6a242179125cf6fc38991558a89a124e5b9b78313d47bdade9166343cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9e56db948adb55205a4f4efaca60e1eb5b8d9c629706dc2bc578bc41f45755"
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

      system bin"bacon", "--init"
      assert_match "[jobs.check]", (crate"bacon.toml").read
    end

    output = shell_output("#{bin}bacon --version")
    assert_match version.to_s, output
  end
end