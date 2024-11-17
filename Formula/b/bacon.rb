class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv3.3.0.tar.gz"
  sha256 "640a6a76213ef4b7337c7a3495afba3056ee5d58b3b7aefebe35edfc9c179e16"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47cf8f3045d8b5e8c57a28f76397201b09c02bcc7b3db3014f062511adf33ca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62d1578a5aabad3db9263edbbdb9865f15edda0402209da5f3e546c53f128f18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46f23ac97a5a47007d0971c1c593c66f461b8b6782b3fe51582d19eb10ae32bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "463bef0a9c3c47d3a24efe44cac09e50cea316c10e39bb0c3e72d3745e09ca72"
    sha256 cellar: :any_skip_relocation, ventura:       "11f9c86cad951ec5c1fa451311ddf0503f7335270edb3b0ccbbd348b473e39bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "002ea633505c605c90641eac2040abd75bf2de9b7732d9ad1b5abcf90665227c"
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