class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.8.1.crate"
  sha256 "be0b930db736a19ee49155d625754b1cda0c6e0ffccad084080fc6b583240116"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "365c6d55131b22938ddcdec4c129eb6e1a04522bc47c40c365f13476edd08188"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6750ce3f211958a58c4942f1af7a96e00e592d7e858606a7a7cc48d5fd155d32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "656350e5eb9639f89f6127d320b6a8c61ff7ff11dfa16580a681fce674887540"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef1887d896bca49e4f862811a1badfcb1d2a3d0c91f1514706f5b509ef9ac824"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b20fdd2b90aa44e5aed7506a639b6340f29d5f88887bc7d1c72fdaf8ecef342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "779385598dfb3297f3d3a7345b4d2550e59f2d7f6d69b2f8df43534bb9cba230"
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