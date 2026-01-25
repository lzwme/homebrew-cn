class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://ghfast.top/https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.20.tar.gz"
  sha256 "9bdf7c10b44466a7c01dc4ed152da5031793cca9e0c8009d73223a32522cf2c3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5ec0938b762dac2f00cffb75c65f16b21dcbe318c8b0139fb88f4a9420320917"
    sha256 cellar: :any,                 arm64_sequoia: "df057729dc96660808773283b561781b60357580fb693e19ce07dab4658debbd"
    sha256 cellar: :any,                 arm64_sonoma:  "4a64cf07223a9388b98fe5e79ddabc9f48a949cf790c72adb1baee8fddd7d21a"
    sha256 cellar: :any,                 sonoma:        "3e68cde1e6e4176e802bbcd4c3f5d48520c62a902b1f9946ea1d5f4aaf652a1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05481276b5fdfe6fc11db58d3141cf51fd4aa650475615411b9497c718a0ccc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "016c098c27ca8c651af617b38079f3086b2ddb35ffa80813b4597bb7ed6f4511"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # this is a workaround to allow to build against system curl
  # see discussions in https://github.com/Homebrew/homebrew-core/pull/197727
  uses_from_macos "curl", since: :sonoma
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end