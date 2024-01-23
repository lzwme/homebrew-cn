class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.14.8.tar.gz"
  sha256 "f6eb0a9bfeca201b9ccf9910d63426a48c6d1397b22f5c2b68e9276d6ff1d495"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5d9b0edce4f34518fe14f72f9656e8894625eea401e1c90bef1673e32895b46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7e02276924bcadf4cf0fa1917398042bca6a2ce660772f82dc4af72a9ac9ea9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b99a092e036453661f08ff310a7131c89841d752382189bd9528bb26319e2fba"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2b59dee751e7e891be79100f806ba2db7e2cec04cf0174796ac69e18f6f5725"
    sha256 cellar: :any_skip_relocation, ventura:        "c2152961de4bdd35690493db4f39f00dc6b452de64d925da8ec5006b22d432f6"
    sha256 cellar: :any_skip_relocation, monterey:       "521e68c733c37851b06c41bf93c896bb0b0c55793fe61e637a51cc3a573d5a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b94a6f0efaf24f1c9e9a69f15c4af660c18545d4c04b1d3a8cca541b90bb4fb5"
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