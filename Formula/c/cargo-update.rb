class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://ghfast.top/https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v22.0.0.tar.gz"
  sha256 "36a0f719ff4d24932fac1bda65610b222996280d974a931bc7b457e89564da61"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "13e9cdb7e52c32a28356b3e9ce12cf8ebff2b28f325ed680b924e44fe26685f9"
    sha256 cellar: :any, arm64_sequoia: "8f6a29d4cf70727a45d345a4f0c0c325a0d0e4494485943b6152d6a82f5c71a4"
    sha256 cellar: :any, arm64_sonoma:  "662c70be5ec4a2cc4aa7386b38e9a56b151241e5b392e4a4e2466ab38a5b1523"
    sha256 cellar: :any, sonoma:        "eec82c2f3785f653423abd915c86103b7526547f55d31311bcfc689d20edb34e"
    sha256 cellar: :any, arm64_linux:   "b324d3a675b6d6c9518da6382c464cac389f7a63d1ea86228030d96a5f399e38"
    sha256 cellar: :any, x86_64_linux:  "b99ca3160b135646158bede50cd70477a065a0a9fd178d01de7f04df6d74717d"
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