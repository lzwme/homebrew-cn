class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv3.7.0.tar.gz"
  sha256 "c439767c6ec59ff91fddfdffd7581697c9db051d086c23e928633f73ae0f8533"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cdfadc26203028bd28810b9b5d6d3c092a64ab0923c7474f6511aa0907f5a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a25677036efa8b4be19e8ae3ed7d0e818e51431669109e97abe7baff97e201e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36d37bee11be67380ac69d7b43f1099aa3c12265490e453bede17c06a02df253"
    sha256 cellar: :any_skip_relocation, sonoma:        "9669f3a172984d7347da897541df9c797cdfe4ba5cfc3d7c02db1a61da6e9298"
    sha256 cellar: :any_skip_relocation, ventura:       "8b270c281f8e77a87d01ad287d4ac2e87e737238ee6df41f55315043e8d1c4bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "750ecb5f1838975eea1e9d402d51df6e91c1dd0b971b997459bd65356e25b165"
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