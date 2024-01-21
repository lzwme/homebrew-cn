class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.14.5.tar.gz"
  sha256 "78b34e6839f34beeb4bca1c0e6adeb34076c34fc89b03ea18d82dad851a3383d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04e7d495a1a15c8725f2131f1a1b2de98cb0bb9b1c12d40a74066381bf8982d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79af3fa23a4510bcdaa1a286487e8292b55f52fedc1cae96d5d6da5fa607937c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "227dead90ae4486353e27a1ef03fbd744fd9f698b37c85a14ae8c14db6d92bbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "07e6e37e8988e179451a34b0a0ad9fe164fe35732bb0a99098228c6b21d550b5"
    sha256 cellar: :any_skip_relocation, ventura:        "f9540ce9fc4a5a88d2d86b4afde60b6b8644c5c6e8740b0f651a7e511d2d7792"
    sha256 cellar: :any_skip_relocation, monterey:       "de2e5c106cd540188abb91d3d5f7cb4911a1b0a98bb416fc4c52d931d07ea2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbd3bf450c69961cce998d9785a28104264ffd392c31bde2a3e3a124b9a5cf38"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE"cargo_cachebin"

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