class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://ghfast.top/https://github.com/pgbackrest/pgbackrest/releases/download/release/2.59.2/pgbackrest-2.59.2.tar.gz"
  sha256 "dbdc5edb5161c57bd3ae61e416b1cd763205ad6ce41d9356114432a0cc0ce577"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7d311219289993ac8ea9743aa0150acddc3c8f73b61d6074c4a0ebe7f2c55ec3"
    sha256 cellar: :any, arm64_tahoe:       "cc97f013b76516d4e7f9af80fa5f88601e0176bfee1d1acabc7807aa842fabe5"
    sha256 cellar: :any, arm64_sequoia:     "fa6371227704f3903d8cf874d461d36acfec0ec41f6c9e30cd98648321de45ec"
    sha256 cellar: :any, arm64_linux:       "57c174eae8e358c247b6a3ae4f2713729cfa1781ae71670ff8bbce991b7545ee"
    sha256 cellar: :any, x86_64_linux:      "192f7c176521061fbd04700a9c2cd87d13b5f72e41d85e9223a06a10d3bda760"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libpq"
  depends_on "libssh2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: formula_opt_lib("libpq"))}" if OS.linux?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    output = shell_output("#{bin}/pgbackrest info")
    assert_match "No stanzas exist in the repository.", output
  end
end