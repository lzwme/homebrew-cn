class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://ghfast.top/https://github.com/containers/crun/releases/download/1.29/crun-1.29.tar.zst"
  sha256 "d4846ce8407cd78ea322bc7daa8a75f7cbd2648a22eca4e388b84b87510b8352"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any, arm64_linux:  "f12a89eea3e3a99fd6ae63f9e00251c8988fa75235312aafbe5861296ceebd12"
    sha256 cellar: :any, x86_64_linux: "a961e30e56074e998b9a311057a47af15e8168d9705c66445dc50b63324e557a"
  end

  head do
    url "https://github.com/containers/crun.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build

  depends_on "json-c"
  depends_on "libcap"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_empty shell_output("#{bin}/crun --root=#{testpath} list -q").strip
  end
end