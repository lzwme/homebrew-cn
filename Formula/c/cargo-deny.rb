class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.16.0.tar.gz"
  sha256 "34f9c1d463b1e2c32cfe9f928e4510210341db27fae55387d7faaa31be2e583f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22a90459719b18e71ce7093061b854202283d0b44c2f3de91c7f675716766301"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec653268f969ff5de3475afe3321e309d7c08a9ba208e6269babab85f6cc376f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e462110f9b85586a095f1021eaf0e3805f98d67a36573d801e151e1cfe8b11e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fab0573267be4e7024ce0040e3ea5a5ceebd12a842bbbec64f4b6b0ab6e8b4f9"
    sha256 cellar: :any_skip_relocation, ventura:        "2fb7a0a74f27aed37000e4469ced9a3292efe1aa5d421bde8c12e8ab85e2d608"
    sha256 cellar: :any_skip_relocation, monterey:       "1697f22b20707ec7dde7a330a9faec24d9d8e4bc4dbc5f176ffcca966c27ba35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69ae11a8a0ebd25b00f3d7cb6b2a712b73c7611325c934c67e22313a7f033a74"
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