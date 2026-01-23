class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.24.crate"
  sha256 "9e7b0ac0ba19c67fe7d8c999c82a00a93f852f53c3f05f76f96ebb09827de3c5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70f7bd25d1d3bdb686a70ebd437535c18ef5e2af7f3d4119f98c84fb1ba6331c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab28f91233fe6a85b5b0d750b4a50de04a50075dce4cf03b76be7c4e79332077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1080e88cf5bcdd1a8ecf3c0ae7efbddb03f48aa7088edfc1e287b95a2ac4d17"
    sha256 cellar: :any_skip_relocation, sonoma:        "b75635139445cfb25458928fc46d0c6afb90af52de7c59eb2c63871eafb92017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6cb3f6334bf4113d83097af1fa4ee57e6feb2abd7ef6bddf8d9c2bc113bb89d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d198082bc68a1096ccdb31d0140b63394a12e5f22b69dc53d2f1804271e8beb7"
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