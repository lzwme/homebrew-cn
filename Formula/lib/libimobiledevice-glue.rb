class LibimobiledeviceGlue < Formula
  desc "Library with common system API code for libimobiledevice projects"
  homepage "https:libimobiledevice.org"
  url "https:github.comlibimobiledevicelibimobiledevice-gluereleasesdownload1.3.0libimobiledevice-glue-1.3.0.tar.bz2"
  sha256 "96ec4eb2b1e217392149eafb2b5c3cd3e7110200f0e2bb5003c37d3ead7244ef"
  license "LGPL-2.1-or-later"
  head "https:github.comlibimobiledevicelibimobiledevice-glue.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33ef233dc222d0a1cb968693cbb2d3ebe64c7c6e19138f2a1e6b338b451e7e59"
    sha256 cellar: :any,                 arm64_sonoma:  "18dfd61323aa5973369a9d77e3343ca6c90bfc18214bce5c4c93642a61f0a2ca"
    sha256 cellar: :any,                 arm64_ventura: "c461d006a85e5ae261f6ebcd6ae6f2f95d91e139bfa7ada5d15c93d06f0f20a1"
    sha256 cellar: :any,                 sonoma:        "efad4621146934106b6811d6c5588b77360ddcbf6cd54bffe4f9782863483c1a"
    sha256 cellar: :any,                 ventura:       "2be57556681deb2cf330e643fa0c3b2b0df6ffd63a246b432683a97a13da02e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4839a357a7b595fbff0c07339acbb8b23346c324d21537ad741320525e0c5700"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"

  def install
    if build.head?
      system ".autogen.sh", *std_configure_args, "--disable-silent-rules"
    else
      system ".configure", *std_configure_args, "--disable-silent-rules"
    end
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include "libimobiledevice-glueutils.h"

      int main(int argc, char* argv[]) {
        char *uuid = generate_uuid();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-limobiledevice-glue-1.0", "-o", "test"
    system ".test"
  end
end