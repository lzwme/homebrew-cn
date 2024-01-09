class Iputils < Formula
  desc "Set of small useful utilities for Linux networking"
  homepage "https:github.comiputilsiputils"
  url "https:github.comiputilsiputilsarchiverefstags20231222.tar.gz"
  sha256 "18d51e7b416da0ecbc0ae18a2cba76407ca0b5b3f32c356034f258a0cb56793f"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https:github.comiputilsiputils.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b5210ac3b74c8ae63cdfee5157f59ec09eec7e25a9e6bca4bb44c68c04240117"
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