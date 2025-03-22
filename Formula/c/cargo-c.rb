class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https:github.comlu-zerocargo-c"
  url "https:github.comlu-zerocargo-carchiverefstagsv0.10.11.tar.gz"
  sha256 "8a6d6dc589d6d70bd7eb95971e3c608240e1f9c938dd5b54a049977333b59f05"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72922f9c6392a632e273f4c5ccb3fcfcd244a40be53c86c3b6db568e41843c6d"
    sha256 cellar: :any,                 arm64_sonoma:  "2f7695eb2b1076b9300adfde23ea2fe15227500823687969a7f9eb4390616abb"
    sha256 cellar: :any,                 arm64_ventura: "6d31ed9a27a0d2609bf55af6c6a01671bdeab5e45b79b1a3be17c19633a6a2b0"
    sha256 cellar: :any,                 sonoma:        "762a8cea56c31c21404c17cada0a25ab162c2bb6a8296be4dd337efc5ff79bf5"
    sha256 cellar: :any,                 ventura:       "1cf30254d83901dbfa27cbf8585cc0d027d0cf15e725c08c585302c206d1e30b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a03db41e6652d8e8bc621632789976b06eb093a60b5a12df87e4367b1a41ed7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "836cb915f1bfa3ed234d56b364027f8dc00f0c80916bace72688bbd2376abeb3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
  depends_on "libssh2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # this is a workaround to allow to build against system curl
  # see discussions in https:github.comHomebrewhomebrew-corepull197727
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
    require "utilslinkage"

    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}cargo-cbuild cbuild 2>&1", 1)

    [
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end