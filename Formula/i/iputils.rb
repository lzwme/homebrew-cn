class Iputils < Formula
  desc "Set of small useful utilities for Linux networking"
  homepage "https:github.comiputilsiputils"
  url "https:github.comiputilsiputilsarchiverefstags20240905.tar.gz"
  sha256 "055b4e6e4f298c97fd5848898099e59b4590db63fac3f7ad4fa796354ad44403"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https:github.comiputilsiputils.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "9881e8da206fa156f109ae29a816d2927eee1366b5f38e32c22cbcb7987ab14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5e17cf0b22d54026f33a2a0883726815e6a98b31a838e2c644b6c2b219c1b934"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "libxslt"
  depends_on :linux

  def install
    args = %w[
      -DBUILD_MANS=true
      -DUSE_CAP=false
      -DSKIP_TESTS=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ping -V")
  end
end