class Bacon < Formula
  desc "Background rust code check"
  homepage "https:dystroy.orgbacon"
  url "https:github.comCanopbaconarchiverefstagsv2.19.0.tar.gz"
  sha256 "a5c9af533fc9b1097b2c60aa86b086367b8799ee10b1b33e0e04fffdb9723b8b"
  license "AGPL-3.0-or-later"
  head "https:github.comCanopbacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c3608015c2c222ec383a2a335f048e2d4235a9b5bdd59bc299b898e162df188"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8447a6608632112377b9c3ac0cfb34083401e5d2f0f5b3cb2d39a5ea00b2bfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca1d4e4e94ac73ccf089ef087fa1a291bc0890ae458fac54c2b956174c4b113d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4df473cf27ba8cf85af26dc2d9fa9e6aa61405b7cce2489d6eb78e7eb5e82613"
    sha256 cellar: :any_skip_relocation, ventura:        "1f1ba5c2c7c43e98be65dd91e1dc319e59debcf46df5d654a851f97b7f371d85"
    sha256 cellar: :any_skip_relocation, monterey:       "6fe312833dbe37129dba8170847231fdeb03b4d2141e4a7043e1536ab2932b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e23010a7891b65e4a20cc0b9e895ed46e8fff1737d8ff4c26d42919afe617db"
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
        license = "MIT"
      EOS

      system bin"bacon", "--init"
      assert_match "[jobs.check]", (crate"bacon.toml").read
    end

    output = shell_output("#{bin}bacon --version")
    assert_match version.to_s, output
  end
end