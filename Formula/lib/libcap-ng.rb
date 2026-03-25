class LibcapNg < Formula
  desc "Library for Linux that makes using posix capabilities easy"
  homepage "https://people.redhat.com/sgrubb/libcap-ng/"
  url "https://ghfast.top/https://github.com/stevegrubb/libcap-ng/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "df6910d996818848de92db9c05f96492e008c4e35f96a8673f9b7cc44f5cf813"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://github.com/stevegrubb/libcap-ng.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2406b612f7cd52a073608b4cf819260270d50a491ae1dd4d47f7d901f6076155"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "28c4e76257163080c73ed6a432e2e392abdfd293349333f0836545dfbc87d29b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "m4" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "swig" => :build
  depends_on :linux

  def python3
    "python3.14"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-python3",
                          *std_configure_args
    system "make", "install", "py3execdir=#{prefix/Language::Python.site_packages(python3)}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <cap-ng.h>

      int main(int argc, char *argv[])
      {
        if(capng_have_permitted_capabilities() > -1)
          printf("ok");
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcap-ng", "-o", "test"
    assert_equal "ok", `./test`
    system python3, "-c", "import capng"
  end
end