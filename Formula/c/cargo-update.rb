class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://ghfast.top/https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v18.2.0.tar.gz"
  sha256 "2ad5fd5247fa6b3eb70202adf90eeb2941a7e1f8cee80b7d374163e484693059"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c34045c3ee515d61a047cda873a42bc6851c94465ef2658f22ee92c59df7d3e"
    sha256 cellar: :any,                 arm64_sequoia: "09408d4ab37338f10203f68be0cc64dd81edbed4b01857ecd49f2704d227ce8b"
    sha256 cellar: :any,                 arm64_sonoma:  "e901a221511298d425d256655993b163305b32558e39697726dd15d86d70598f"
    sha256 cellar: :any,                 sonoma:        "c673b6b5da5eb3ec536909f283312779523a36bb74329f82344127de9cfab2b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1850c447804ce9300b0021f2453ca8eb87c789eeb6ce5e2bb51b498a1814a811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "854e37dffe885de0cdeeb36390da674633bdcbb27d677f9299b3c86a7f26fb91"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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