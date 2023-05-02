class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://ghproxy.com/https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.9.19.tar.gz"
  sha256 "c2633ff22e52da9985394f30c8ef5e9abbac4d14c9b79e3690c8e95cf500ab97"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "097654c19e3a973d98a21bb91a2740b7881e070dc889cd182ddb7a12906d156a"
    sha256 cellar: :any,                 arm64_monterey: "04dad0f34ebfd5abe31466762ea6e6b8c812f2cd3ca236a3c37dbd5526314ee3"
    sha256 cellar: :any,                 arm64_big_sur:  "4f244e8b64ce2123b8163f8e5754548220353672b6af03b0d32b886c80f20340"
    sha256 cellar: :any,                 ventura:        "9179fbefd530ca990ea0d91ad600c0454b95cb7fe62bd92116394cfb3a2cf739"
    sha256 cellar: :any,                 monterey:       "ffd444f86152608d3083fea18bdda1c9e06b63419ff5e22ae073163129f26aa8"
    sha256 cellar: :any,                 big_sur:        "2484eec666c65c8f1f03120266c6dd18d2e4f8518805432181db17e8d2586451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49590a93060b83dd6e882325889cc38d7f23527aeb0a3251818da4514052a849"
  end

  depends_on "rust" => :build
  depends_on "libgit2@1.5"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)

    [
      Formula["libgit2@1.5"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
      Formula["openssl@1.1"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end