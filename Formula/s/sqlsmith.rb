class Sqlsmith < Formula
  desc "Random SQL query generator"
  homepage "https://github.com/anse1/sqlsmith"
  # TODO: Switch to the release tarball when the next release is made
  url "https://ghfast.top/https://github.com/anse1/sqlsmith/archive/refs/tags/v1.5.tar.gz"
  sha256 "828ee3e816b94848627e8132d32ade6339dbcbba5469437dc9a6a8335d4dab23"
  license "GPL-3.0-only"
  head "https://github.com/anse1/sqlsmith.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c547bc945c73c4e8d0b7dfedb71bb8b4372068fa260fbf4ecde161efaf4fb3a"
    sha256 cellar: :any,                 arm64_sequoia: "35efb66704fb6cf29d832823e6cab48a92f1c0a30df4bb7b9d4699788e94720b"
    sha256 cellar: :any,                 arm64_sonoma:  "ab8f73e1969c5f24008cf28c94d0a1b73910b1908e5060bb3f6cd976d7ff9857"
    sha256 cellar: :any,                 sonoma:        "73809eac58b1f707bb5f135987bef0139f2fe055cc1200069a360069058c8726"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e8398625f314822fafceecb894a9ad9f49a2512c3e09934676da77177b0c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c973b5468170072a581d3be4639718a2daf6268bc79c88d3e0f22807fc15bbba"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build # required for AX_CXX_COMPILE_STDCXX_17
  depends_on "automake" => :build

  depends_on "pkgconf" => :build
  depends_on "libpq"
  depends_on "libpqxx"

  uses_from_macos "sqlite"

  def install
    ENV.append_to_cflags "-DNDEBUG"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    cmd = %W[
      #{bin}/sqlsmith
      --sqlite
      --max-queries=100
      --verbose
      --seed=1
      2>&1
    ].join(" ")
    output = shell_output(cmd)

    assert_match "Loading tables...done.", output
    assert_match "Loading columns and constraints...done.", output
    assert_match "Generating indexes...done.", output
    assert_match "queries: 100", output
    assert_match "impedance report:", output
  end
end