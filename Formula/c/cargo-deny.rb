class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.15.0.tar.gz"
  sha256 "51a147bfb2c3886c6083ebc0087df711ba610c34f63b457a2190ff79acaa76fb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "593bc17ec17a0b9b5417e97790e227f77430794928bf68e9ec83b0acee2e8ffb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "572bdfde59ec6d7bd1f219e4a20acc5a0de9616129d595654b879431e9a7fdac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ff2ef54d0dd684776e0ceae447a7dfd209204e93d24ca4b69f5744654c2b62f"
    sha256 cellar: :any_skip_relocation, sonoma:         "458847e29157b41f44c641954ca9e79dee1c93d53597488a9f67c0047048d197"
    sha256 cellar: :any_skip_relocation, ventura:        "d63cdc0fe35c5d33588b3f957deab4fdd15d85190cddc403e74e6d8b554c57c4"
    sha256 cellar: :any_skip_relocation, monterey:       "f7922bef5589a26b5bd93cda301f4e0647e55883dfc18035965a79a1e1511387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbed2224f99d14a8c8381eb29b668b9c737fc18f164a841e79fd4e41890b1488"
  end

  depends_on "pkg-config" => :build
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
      (crate"srcmain.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end