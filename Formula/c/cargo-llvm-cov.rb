class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.8.3.crate"
  sha256 "018451183b0172d9fefd15ab378f659d0da32c3d6040749e452113f4bb0f6886"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "541bde3e43b37dc62125a625f8e98c83e25c02c368b3d70bf2ed6ab2dd4be718"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70015647919901d7edf6b5b84943c1b94efb4bd7b663827535d9c61aef93520c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f989a701380e03b16de10524a7b0e46f5ece4dbd5ebcef68855a4c2e173c4a99"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fc7ea36ff39f8666e38dc9076cc153c9150ec16780329c22f8cc4ba0a9664c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9303ea9926f2b16dbee6f44ae7fd65a303e88cfa5ac7c57ae879153faf7d065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ecfedfc0b4f79b85dfc37e83a857dea1530d2ddbbf2ef33014814f5a36742ea"
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