class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://ghfast.top/https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v19.0.1.tar.gz"
  sha256 "3f71d07f20bc8fe46f8b37a59dd414412e62b5ba01738a384d3c9c0e93d63676"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d05c66a788b82dc2d7a5115989dd178228b7a66669eae145bfb4413eaa608767"
    sha256 cellar: :any,                 arm64_sequoia: "8369d287b75aeca29bc69d2f19df639115f235fdfefffacd0d278666657eba95"
    sha256 cellar: :any,                 arm64_sonoma:  "390aedf00c7af89ee310b2a090cf2db1dbf9db27b6c1396ccfd71c9532c6e267"
    sha256 cellar: :any,                 sonoma:        "260037fdfb46777606c117c61a11bc368a25330a2d1621b9b27ed4a012ddd351"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dd30596cd823d9e41530964d5a3d69be477fe48741e782f65881c43cd06e698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fadb436fe80d08a454877baf24ae13210a99b9ff5c1dc6767adb55977dbc3d0"
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