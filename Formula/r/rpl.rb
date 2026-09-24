class Rpl < Formula
  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://ghfast.top/https://github.com/rrthomas/rpl/releases/download/v2.1.1/rpl-2.1.1.tar.gz"
  sha256 "c3298cac724b82a6f71e8c31ef15627e53dcad9afc40411366d2ac90988a53d0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ed0e5aa3201678b41e1bb3b1df21af6c1f455f7e0f0f568fa99434b9d278a486"
    sha256 cellar: :any, arm64_tahoe:       "5f7ad6e07f85b121c668ca396528095e7c7863598c9023f20dda1ca3810374b1"
    sha256 cellar: :any, arm64_sequoia:     "d9e58f3b1811c814774aa5d9a74a7a25fdeb9529bf83efaf934b9b156e1d49df"
    sha256 cellar: :any, arm64_linux:       "0f0bad3a569ee5c8b98c0c00224ae2d922a02871486c27937bb9b3ec6eb4686f"
    sha256 cellar: :any, x86_64_linux:      "f5ca2ae431d0ea21c46e5faa91bcf49dcf649f8dbfa97a0b05194591ebc4c716"
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "pcre2"
  depends_on "uchardet"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test").write "I like water."

    system bin/"rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end