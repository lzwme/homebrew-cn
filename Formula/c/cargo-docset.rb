class CargoDocset < Formula
  desc "Cargo subcommand to generate a Dash/Zeal docset for your Rust packages"
  homepage "https://github.com/Robzz/cargo-docset"
  url "https://ghproxy.com/https://github.com/Robzz/cargo-docset/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "98e7aec301ad5840d442f6027bba02b41de3f03b1f3c85b23adcc6dd7ca8c415"
  license "Apache-2.0"
  head "https://github.com/Robzz/cargo-docset.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d3967143668a150164b116c2f82996ed07bf150f8c2418d913fce73c0414cb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a026716e38bb7746b1118556a35fd319beb8e46d9a07d02c886808cbf77bf31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cf48a777532c29c0a4885d1460892d9c68ce0f19115381b95ba10d1aebb174e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "873269e236d771aa5c98df63927b7a54db5213d2915c868f1a090033a97f59c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "06d504afe6263dcde05f4b4966709b18af92315239c12375d7cddb7d0148ab72"
    sha256 cellar: :any_skip_relocation, ventura:        "86dafa007c5203f459d7b4d95db972d2820b94f97f8d4c7ae2578ad4d0651056"
    sha256 cellar: :any_skip_relocation, monterey:       "f8d40c7c3a89df7dff6b6a752a83896e621a6b81ccd3361568da5feba36a8c72"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce6ee7c8b2ee612c55eb082cc14e34a109c99e517948ed6be22066e0d066b9f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d451753648a8173e81f0238eb79b57da1d774c2c444b3de0618277c38d9889f3"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        fn main() {
          println!("Hello BrewTestBot!");
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      EOS

      output = shell_output("cargo docset --all-features")
      assert_predicate crate/"target/docset/demo-crate.docset", :exist?
      assert_match "Docset succesfully generated", output
    end
  end
end