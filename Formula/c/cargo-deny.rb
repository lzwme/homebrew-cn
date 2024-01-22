class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.14.6.tar.gz"
  sha256 "f63b2c3be3a110496cc003f7d78fe54824756b30e24239508774eadbf37d085f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6e3d840b499e3de05075db8cde80685f120b14cea57868502a8a3bbab24f59d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc14050a3791c19c2119993da19d921328c3e60937f36f6d7d8185407969cb68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "504fb189ac41cef099cf20b68153f9ccf0e9a44f93bf545cc93708e41ae75514"
    sha256 cellar: :any_skip_relocation, sonoma:         "74c08d684718f1f277dcfbeaa9fd4180738155811f70f1caf3e40e193038b9e9"
    sha256 cellar: :any_skip_relocation, ventura:        "f86e320e004f202f1e9d8e2194f027b2f8036f95e03306a81ad63aff6eae2f1b"
    sha256 cellar: :any_skip_relocation, monterey:       "6a2729b66991cb6c18ab9b7d22048b1a2df6d8915793799726a168d99601435f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db5c5f77587c735abfca0234e58828c2567095482fb7889d3f10e0c6fcf6fbce"
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