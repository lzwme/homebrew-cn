class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://ghproxy.com/https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.0.tar.gz"
  sha256 "7b8bfa1274d12a209d759ba0df33437164190517787bc9848f28af6107fe07ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95c7490b0b38b3e91b28405f95a008adb544e7ea13fe462e7f1efeafda16bdd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9882e1c0240a14367ddf7d2fb154cdf96e30095ff997fa003edfefc5533c928f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e207f17c022d2bac8042c83f7e8f7bdafaef4930c9cf966a02287caa15c15ae"
    sha256 cellar: :any_skip_relocation, ventura:        "6c08848a911dbb3fc6e027f70f39439689ce45100c28358870d62a8a3fdb89ad"
    sha256 cellar: :any_skip_relocation, monterey:       "f79eab07d717e261f3ba0e12659c6208b5ede0c6441987556fdbcf9bb4dae62a"
    sha256 cellar: :any_skip_relocation, big_sur:        "64b4de57bbf9f0a19203c185b9484c7f6d6b04b2d5ef3dfbc323ed229b2be6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e9ca0a70a538dbefc1194b5c08c00e7e09d46d0123f44f2418f7e947919195"
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