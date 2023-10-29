class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://ghproxy.com/https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.3.tar.gz"
  sha256 "84232d6fee09cdabe03d6348d156a2a80ba0965140f0d9f65b2abb25362ba071"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d683a01c3497ab0e9c1742be4afa440ee4fad4c15ffd36ccb750a6921f703111"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04d2117a77545b04f3f40077a0b4447110bdeb47f12880765b337d4aad42ad94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9fd7be0a710329b506f9c1f43c92d7431c60269e2ca44c18471f4ae7fae5230"
    sha256 cellar: :any_skip_relocation, sonoma:         "9540a472b82d986a65023fa8f64507eb34022234a64e131a5ebe38f5a122c57c"
    sha256 cellar: :any_skip_relocation, ventura:        "0c328cffe7322c7cb7a14cbd5d990a1e44e12565593f16f98ffdd6cc03a8850d"
    sha256 cellar: :any_skip_relocation, monterey:       "eda483c0d358d86f61808bb3fe0990e75fbacd38d9b1e75354758216adf3608d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aec7c2262144cbe0c0f38790998368aadfe959c0c18fa777007b224ec610bb22"
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

    text = "it's working!"
    (testpath/"Makefile.toml").write <<~EOF
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    EOF

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}/cargo-make make is_working")
    assert_match text, shell_output("#{bin}/makers is_working")
  end
end