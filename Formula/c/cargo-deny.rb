class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https:github.comEmbarkStudioscargo-deny"
  url "https:github.comEmbarkStudioscargo-denyarchiverefstags0.14.12.tar.gz"
  sha256 "681edd67143e3458529b5487f6bf3251b36d79b8f67d9974de331ea4ffc69a6c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comEmbarkStudioscargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07db227ad6ff674fa9dffe5d46a3d5e258ed2c48425444014066ebfa7bb33462"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "351004ffc1f4b2c9cfd34f98b09a41545375d62adadacd00c0d7820e3fe15aea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63907f8548ee8167fb5ee896ce5a8c20ec44168c7cb459084a15bab33ffd7dc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba8865f8de61de486068d024b660ed3288c3ce3e990d1323da0ca3e759843930"
    sha256 cellar: :any_skip_relocation, ventura:        "c8b8d6827e5c8be0b0453d532264695d5311193ba7a46d82659e58b62bfb95e7"
    sha256 cellar: :any_skip_relocation, monterey:       "08c23a80c17056b0d1665255581913c6e3e3cf94c9d703c344b7184e0ac0c288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a011189bde60e66c7d93f362b28f811022c8afced0b85f1cd27060915c806d1"
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