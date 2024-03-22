class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.14.19.tar.gz"
  sha256 "a64010365e1aa27d29b9fe874d881bb42aa5a48cedabeee17f437071bff33d29"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "668f8ef575e8268eeee10d86f8c732809e047d4bd5d67ba87a9700389e4a3bf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee9c72c399b1ebd1e82089e4f51d5b34c83e80bd08409441984a0b3c14b95927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33704a0b11c348d01ee9f7804e5f7610a750cb0ff6992e0f14af2f1bf788962e"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc33107e4e111707b94d773d62258610b2645543501030aaba20eabca9087884"
    sha256 cellar: :any_skip_relocation, ventura:        "c11cf532e305c5aad94e76a70186bccf042f2896103cf51c8571bead4c9fe4ce"
    sha256 cellar: :any_skip_relocation, monterey:       "a9f3ab5a9a42e078275bd5006f3eb446500a1f4998f61b3907278ed4746fdfa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb38089439c4028cce74cf3253e479080f581fdb6ceeb24b24dad23d76a16ac"
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