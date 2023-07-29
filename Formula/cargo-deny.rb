class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://ghproxy.com/https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.0.tar.gz"
  sha256 "b100e36c5eb4405067ee2350aea7b5089e9e72f787603fdc3929f6586a69b0f4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "382d09a62741a6e9a28136758009936a27533cc111ca2704a2e211f1fdd3cdc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d618f66cc33822684f57930c7607aca0700999ef1fc3612925419ea8f9b550be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a120bdbd19ad98e7ec92a4eee30979a184bddbcca7f8312f95498a3f44a53233"
    sha256 cellar: :any_skip_relocation, ventura:        "80cc4b4498b33cc6936972a4d99c0d4f3e56aa72309b9bfae28d46ae636f8996"
    sha256 cellar: :any_skip_relocation, monterey:       "8aaef73a624ab81baa858e2a2007e1afd003b18394fe7791da74835bb1779b9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "26b8e0ca5d49a1d978427a880e509a0068d1834ea8f2b9b0cffceee216708522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f575a73d00384d6c5ced0f6f8a3721d6366c6c9416a812ad00c1d173da86e85"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo deny check 2>&1", 1)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end