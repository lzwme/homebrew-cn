class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.22.crate"
  sha256 "5df396dc4dcec0a1423011205e00e1df9eb380f44767b3362bbf1052b2ed3cbc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "449879c3292f5953c8f5db07a896169cdb1ccccc7c22b46e8caebe23f65a17e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc322ce1db8e905423ee3c5825e1f2cbdda4784985e82b7ea7890a7b0f08a1ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cdecc0ecc12f28424b6afef033e920f72d12b7dedbfaa0806b26583fb463b6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "be171d044fa15cf2c8c8804ab4d9c0a04b27120862166f59147879f452c55f1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22cb32c6b96899849597b52a654d7778e0860968fb802c90e600da669f6d9caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84cf1ef86e95ec2bb63213d98f82e6b2cc5b91768b102b4ad3de1c8f4b03df98"
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