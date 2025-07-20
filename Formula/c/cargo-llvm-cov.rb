class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.18.crate"
  sha256 "9ecc469e8c1be87be84e3e3c32bcc92eedca5bb57d1e7f606e10154f564a1f8d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4cf7be2979a75f5e44d933bfc65f2d232d31778f9acd0583a925ddc1d12f8e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66cb280e471b8dee0c300df565f5347ec96fc234e21f89db8fa2daf2a8fc6445"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b0211ce2025fd38a8fc9381a48fffc417bb66c1366dead3ac3786ba2b757474"
    sha256 cellar: :any_skip_relocation, sonoma:        "14e0658573cf1fbda633ce7e07c0186030428d8db869c3e9a091a31084e594e5"
    sha256 cellar: :any_skip_relocation, ventura:       "9819d8e092c911155220056a69b20da2455df41bdd87f1a96882ed291c01ba9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cf191cf24e6d88dfe57323de4c0b9d1cb9aa8700bcd58f0d8dd5ff6ac223c24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "900bbbe824e59d16a56e7b735fd27816fb27240bb6c2570af70ff700fb6be47c"
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