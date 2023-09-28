class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://ghproxy.com/https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.35.tar.gz"
  sha256 "4c681776badfbf2bf987aae374caebefabf3bbb5ac5412c8fbd5097577126288"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd374547f6b8d5afe415e68c89690bd03055a340dde4e0b2dc3730c3d30f0596"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65608afa456f20903770c3ba86f4b46ae2c78a452fb8fb9c0518f215a7a73ced"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "424c630c130ee5dae968eb63dd5f93703da40593facf92776fabbef0d7664bdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcde45facbdb56008dad95732875417ca24868c839e9e2c8243a3a3f50fe0a00"
    sha256 cellar: :any_skip_relocation, ventura:        "b2e286e8eb19a54da7f4c2d7e1cc1c76374799f7fbb15d3309172fe4b19c010c"
    sha256 cellar: :any_skip_relocation, monterey:       "372ee44e7006d1c4d24109bc099b82615aa15cd5e6d5ac5cab9c4e24d77a0581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b95229a7af6568d73446d120b96e434880236f0a01af26c24852bdb2d37bac2"
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
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end