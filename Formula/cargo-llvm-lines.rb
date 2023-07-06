class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://ghproxy.com/https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.31.tar.gz"
  sha256 "602f06b1bf9520a54642ffdda10c02aa04818e7e24005bd821f577992da88834"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07d7bdbc92cd50bbe6d854a7e5186fb8224b11070db7b86caaa913e0d774e1de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3b5fe43849277445376f1ece1dc8c7e669476f37aa4bca6c8bcc42a6e45cd49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa7b68a0d250ac8165c491bf96e050514882680650ce2859f0d2feb84e140870"
    sha256 cellar: :any_skip_relocation, ventura:        "c60ca0ad59e8aead5d3237e06c9a7e39416236a5799ba8517742f993366e578f"
    sha256 cellar: :any_skip_relocation, monterey:       "847c406733a709ebaac45c65e1ec0c89f830e25dab6b5490bb83f7fdff98214e"
    sha256 cellar: :any_skip_relocation, big_sur:        "397e0e4338e61d3f715bcde8e88b4763d229307884d08fe18b5e8fa5107dfaea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eecf2d6eacf111542f4d70d92311fa2fd53ada8a139f7ec5ebc10c9218215487"
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