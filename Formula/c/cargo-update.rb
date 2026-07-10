class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://ghfast.top/https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v21.0.1.tar.gz"
  sha256 "6c970612463ce4acf2f40a4ca4769facc4ccf22548c46b6fcbc0124c71a5e93e"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "84be5f4174740ae9a9884ac8cbc14d12652e670a8c782241fc74b59988315f9d"
    sha256 cellar: :any, arm64_sequoia: "b10be202afdc78d3dd2e6be489cbf92d74a8b0aeba54a9a0aa5481e320f6321a"
    sha256 cellar: :any, arm64_sonoma:  "42c1f83bcd18d22e61dcdacc29288f81767a69864b757f25fa07690a42dfcc1b"
    sha256 cellar: :any, sonoma:        "98aad54fa27846420a5f9dfab3b97c6eafbf82193fa2110bc909cf27a8c12ec0"
    sha256 cellar: :any, arm64_linux:   "b29b78579572a5b00175e1e7e5e7ab8c58771da78464347fbef71d863fcce33f"
    sha256 cellar: :any, x86_64_linux:  "b11718e43d2e66e0eb943cf41c742e41a03916ce525f36703f04bac0031a4146"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("cargo install-update --version")

    output = shell_output("cargo install-update -a")
    assert_match "No packages need updating", output
  end
end