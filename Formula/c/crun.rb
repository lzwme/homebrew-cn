class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https:github.comcontainerscrun"
  url "https:github.comcontainerscrunreleasesdownload1.12crun-1.12.tar.xz"
  sha256 "860f4d1972dd2fdb17e4a1aae4386c4da2989e547d1e17f909b3ca0aff135c28"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9696d3d6240f9437047732ad8d65844f3cdf38584e6e5634efbd299bbe309893"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "go-md2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build

  depends_on "libcap"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"
  depends_on "yajl"

  def install
    system ".autogen.sh"
    system ".configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_empty shell_output("#{bin}crun --rootless=true list -q").strip
  end
end