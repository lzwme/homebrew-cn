class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.14.15.tar.gz"
  sha256 "1313276c3579321316e62595fa4481e1fa3cd1700fe1d9031929b65f8f0fff11"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46d53012936db65652a930dcd45518d9d268d67682c7bd30c89391d652e4f4e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c304781e8b33cd0b61384157c6510a8523a6556f07d510fe4d8adf0931b05c9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bec10e6ba09be8538c55c1dfbf80ca994a014db1d9e260529a1cac170889d21"
    sha256 cellar: :any_skip_relocation, sonoma:         "2775d0c4afb79d65b618e45005225be4da1cd94af358198fb31a06e36d96d3bc"
    sha256 cellar: :any_skip_relocation, ventura:        "5f2705c92e2926d72c65f064776986efa10614df9692c0cd472f333e65996a39"
    sha256 cellar: :any_skip_relocation, monterey:       "94f846b3cd43e717cb4fb2bfe2cb89c545996c76f0f649c21ea54e2c8a9c0092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d1bfd090842fd91a4bbbbe66a625a87008118463c86d17da3a45f94e86a438"
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