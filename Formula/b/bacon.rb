class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://ghfast.top/https://github.com/Canop/bacon/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "2c49ca02687391d425f2cc9a19cae8227338def2d689d55ff5970cb70fd2b7f6"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10395f25be03ed834ca48c32535a85e459ce531ffe2f9a34a77cf2239ed1af5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0524ca75127eb97f2983049a9f232ecc70bbb2ac97ef1bf011f2a6b0fa58d5ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f69aa22695b557fd779e9fd15d4b81a03d7b9db884c23f30ae301198259e3b85"
    sha256 cellar: :any_skip_relocation, sonoma:        "3721d7f2c33acc8b8f63513eb9d04d0d82d00532b264627c8867d2693ec7dece"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeae918c0a5b9ced620ad43aa09fda55cb7b2c6f9c73d9dabb39d308487f8c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9199143c65a8eb63d7f08bce48ba0499343fd6e349aa1d3a39bef22cd2962ed2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      TOML

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end