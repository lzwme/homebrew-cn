class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.16.3.tar.gz"
  sha256 "99f8906b6468ae309c5c7312f9ce1d7567300dcc43cd58228955dcc5522fcaff"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1c4c284dc6939ea816ba37d40a88d5f48a51b743272bfd3bca4b9463dccf549"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "003e30e6665d46434797edbdc9fa2d9b9f55fd093a32afdb6ac4d10ed368a941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02613486cf318b59be5baf5f7ad6ceed86b8d566165098fa9b3fcc402f38ed45"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d9147bbf5c58cf75d299db75a1e365cfcfbc2c4d58b115e96507de6f6b90495"
    sha256 cellar: :any_skip_relocation, ventura:       "823839fb88adf3648cf8a11641a05dd303ff8446e18e185f182df5b7e49f30fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85c35da3998136a78e9c7653c933eec5d638011388c6fe6592f5d8502c8d32d3"
  end

  depends_on "pkgconf" => :build
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
      TOML

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end