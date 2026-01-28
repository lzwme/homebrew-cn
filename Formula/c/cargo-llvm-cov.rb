class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.8.2.crate"
  sha256 "f8132c5e1b6489a345e12bbc3deb7154cb8d8b51bd9d9b168505eff5e5ce88ee"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39e7852744b8e2700eb2608f2170280112ae9f722b50129af33ba6d835feec54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdaf7142ee29839f3b7740a91970bfef3a5aa1aea18ab410e1cb448d95e6f61a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01b78ec6e96d8a78c19279e353cfbff7e3527f04d73ccfc6685385803f08419f"
    sha256 cellar: :any_skip_relocation, sonoma:        "29cc918aeba482449ce5a6cf7d507fae2c21fa9e2ce6a40f441ce3568b4bf9c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fe88e60f30b24f72c797bdd562fa0f9b87faf40c80fb2a1a74edab982079aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d856e2ad22579bf031adc6b3065595ce9c0d4dac199cc40388e614fabe25bb1a"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_path_exists testpath/"hello_world/target/llvm-cov/html/index.html"
  end
end