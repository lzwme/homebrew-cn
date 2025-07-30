class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://ghfast.top/https://github.com/freref/fancy-cat/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d264dbaf05f8713a4c52ce0c74a8d5e900989ec815fac1bbfec7d7b385bc1dd5"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40dab164f64cc880acbfed31805d0026c2f3f8e2e644e7c1f87b70a5a7776ccc"
    sha256 cellar: :any,                 arm64_sonoma:  "45a5040e53274f581d3e978539295e485f87d8c25c0c9893290ff00dbd79c819"
    sha256 cellar: :any,                 arm64_ventura: "2755b20a8ae8835f869cb2acbf4992d775783a5b24bc5f098c5ac6fe43accdbe"
    sha256 cellar: :any,                 sonoma:        "aa11ab824ccaabcca5c5a5e2d787b969625062fd6fd6bcc113bd67e74a82d94e"
    sha256 cellar: :any,                 ventura:       "0b195abf4d1ab975a429bf58351c16de5e3fb2e61c6e6e25dacb5dc590820f8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d1f171a0cfdd015751a0d2dee56273dd8c2e3961a0531d7f3ecf62354477a50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b4795f94d2545b5db437cc91612c4b1b15d27373aa198bbcb0cc3b2ef5b1453"
  end

  depends_on "zig" => :build
  depends_on "mupdf"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *std_zig_args, *args
  end

  test do
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end