class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https:sheldon.cli.rs"
  url "https:github.comrossmacarthursheldonarchiverefstags0.8.0.tar.gz"
  sha256 "71c6c27b30d1555e11d253756a4fce515600221ec6de6c06f9afb3db8122e5b5"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https:github.comrossmacarthursheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b4ca226568ec1d56bdf2d8d38c89f5ffae1194216072ba9505f502085b4a4f0"
    sha256 cellar: :any,                 arm64_sonoma:  "77bcbdffab00767b124322df281f6a5d731aa0a9d07f594e9b5265d4dc26fef9"
    sha256 cellar: :any,                 arm64_ventura: "50df0255e0d8c049b435e20d83346b68cc7cf2490add53214c9cdb67a8a802ab"
    sha256 cellar: :any,                 sonoma:        "995b5d37feedc55e4a9bb14ecc3bec14b935ae7982aad6fecc995935d7cba08a"
    sha256 cellar: :any,                 ventura:       "c66a4800c30bb98897effdad71d930936c0546ed83fe32c3eb5e28665f9cda18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1af78241af1979a6d1f15c69b4707afa43b16c1e3fb2c06e0ff8f8d5bc4e4523"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # see discussions in https:github.comHomebrewhomebrew-corepull197727
  # FIXME: We should be able to use macOS curl on Ventura, but `curl-config` is broken.
  uses_from_macos "curl", since: :sonoma

  def install
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https:docs.rsopenssllatestopenssl#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Replace vendored `libgit2` with our formula
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "completionssheldon.bash" => "sheldon"
    zsh_completion.install "completionssheldon.zsh" => "_sheldon"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    touch testpath"plugins.toml"
    system bin"sheldon", "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_path_exists testpath"plugins.lock"

    libraries = [
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]
    libraries << (Formula["curl"].opt_libshared_library("libcurl")) if OS.linux?

    libraries.each do |library|
      assert check_binary_linkage(bin"sheldon", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end