class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.14.10.tar.gz"
  sha256 "c8c157f46ddbeea80da79f6bb13814730c88dd18c5d1f1c9c67247ac48f74237"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9fd2a6b8e95020aff472340f94d5f081cf2994127f7874cc0c5581352b4fe37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d3c6c0fc84957fa5ab2fae524247b19598e9266ee618d42c40d907ad7e3243d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f45c3cd92c88e0efbaa6675901a09d688a35d730dc9fe7fe525aaa61bbb6c99"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa414ea19a9d7262628848d8cb97c34d13521f436813196a4cc23cb120345cd4"
    sha256 cellar: :any_skip_relocation, ventura:        "fa1ac6b434816c16aceee9e7ea1a2dfc90bbf196b0bc61f5b6eb398f948c2d8d"
    sha256 cellar: :any_skip_relocation, monterey:       "8477c08eefa42cad6bf47b6f34b58c6339bdf36b11b2e10fe6f2c12d7106ed9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f690364b0f60caeb9b74a772397bcf4e4d1c27b5e8b84ef76eb6522d79b9eb5c"
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