class Discount < Formula
  desc "C implementation of Markdown"
  homepage "https://www.pell.portland.or.us/~orc/Code/discount/"
  url "https://www.pell.portland.or.us/~orc/Code/discount/discount-3.0.1.tar.bz2"
  sha256 "472c31c84b0c00962ed4f004889de4b0745b18f7865ad5b9aab07fd84dd2971e"
  license "BSD-3-Clause"
  head "https://github.com/Orc/discount.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?discount[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe868a08f37631158d8593bb92478e3255922a9985bce4cf68b82d000e643dfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77da10c786ada0d1f8662116785f02912de5f4fd91d1fd17e42a20e8c2c265f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12cc858e4d4bc7ecac75e8d62bf83de60f0c9c39d0500534ad28750f5c1f0b7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ca70243f01fa27667c5f432cbdccc32d11f1ffbb9b29f44f6ecd191be9236a4"
    sha256 cellar: :any_skip_relocation, ventura:       "54073d10de9923a4217fcd57c53839346d4e83d5414049e7c20568cbd3773c57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e32997db104c559843d5805b71389e043e0d39b7f0230e9e641eaacb1a7aa9e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e811cad709cdca1302ff9f4415587dd0e6b4be233a8dd3ee2772f0375d06c60"
  end

  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "multimarkdown", because: "both install `markdown` binaries"

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # Shared libraries are currently not built because they require
    # root access to build without patching.
    # Issue reported upstream here: https://github.com/Orc/discount/issues/266.
    # Add --shared to args when this is resolved.
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-dl=Both
      --enable-dl-tag
      --enable-pandoc-header
      --enable-superscript
      --pkg-config
    ]
    system "./configure.sh", *args
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make", "install.everything"
  end

  test do
    markdown = "[Homebrew](https://brew.sh/)"
    html = "<p><a href=\"https://brew.sh/\">Homebrew</a></p>"
    assert_equal html, pipe_output(bin/"markdown", markdown, 0).chomp
  end
end