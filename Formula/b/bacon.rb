class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv3.2.0.tar.gz"
  sha256 "d8b516b0af8564fbd470513bd6420ba077e74a3860d655efaf9ec12fda47e7a1"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27dc98dc99ca5daffa24b6bbbbfec91aff54967b35b1efb9ebd1ced30b057fd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aebdd99f7d2e3bf7e3edb884f58fa6a155b28fc7922925a3829c3888abb2c5f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6f40efb2b66384f31445203c58200c80030f0d0ae82ab3dff1bb1dac1970c8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "04f5dbed65607a874c990408f54899a41d7ba8b7e958803f466caf5619d99a33"
    sha256 cellar: :any_skip_relocation, ventura:       "3e8406a249be4f21ecb7bd9635bafbb798549c9f2cfe4241b5ee3182e7d31b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa85dacede75d76e8f7f4821230ef2345b7bde4f91215c7c57f8bba1b4985d71"
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