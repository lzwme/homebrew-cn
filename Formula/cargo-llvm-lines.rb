class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://ghproxy.com/https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.30.tar.gz"
  sha256 "3cd6a1e19ab756f7981b9dd3ff93e96de543b9d0489322d671404e570e241070"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16a7d65470612790956c31b8be65addc1846814fbf70b36261872c653a16f859"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0265b0978cb92d85fc16a24036c6141183699ce2219e7f3d0d10ce9d013adae0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d73941ccdfde0ab0973b66bd53024ccf58c1e0efbf77bb8edea330c8631cbec4"
    sha256 cellar: :any_skip_relocation, ventura:        "dde2f2a059783967e4f3400771edb4bda5cd898f2327af3c4548478302b0c5bf"
    sha256 cellar: :any_skip_relocation, monterey:       "d05c8e0b7af6e9733dbf3a866f0b1b7d1a6f5888d22d42da232fc351b25ab661"
    sha256 cellar: :any_skip_relocation, big_sur:        "164d11949c61b5981c9f1ff18a7a0b4d49095325b6a5fa74a8302224a9146203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "912cc2b99e78cd5720c2ab567e122d577d389727002b9a15a95fe76633bda931"
  end

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

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end