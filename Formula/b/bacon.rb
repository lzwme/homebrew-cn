class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv3.5.0.tar.gz"
  sha256 "a5819aa6b5a56d089dba3e51ce469845af84b7c6feeba02f21f038ea92accad9"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "729f62e7b646fe3aacb429534f3384a30345e2a376c2d5e3b4288c46525d8355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "403f11c363f1902af34b9e380c94d3ad135f2fed7fa470963270f6e018a55227"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0acbf37b5fab756528e552743a9082f9aadd45ae0be47763174ac510e88ba1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd28e64940ea86eb0da80f4e1845266a1e6211b8d40f162debf30140f5a2d1dd"
    sha256 cellar: :any_skip_relocation, ventura:       "5ca5bf1343257fc45f137d5ac00f40c418b4e09c693009fcf9c85f10dabfea5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e22960a7a8e6d34f08513b0c6d0f10a87b2e0b3a50eab17211ea112de090d0e1"
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

      system bin"bacon", "--init"
      assert_match "[jobs.check]", (crate"bacon.toml").read
    end

    output = shell_output("#{bin}bacon --version")
    assert_match version.to_s, output
  end
end