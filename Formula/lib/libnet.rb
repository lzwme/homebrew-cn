class Libnet < Formula
  desc "C library for creating IP packets"
  homepage "https:github.comlibnetlibnet"
  url "https:github.comlibnetlibnetreleasesdownloadv1.3libnet-1.3.tar.gz"
  sha256 "ad1e2dd9b500c58ee462acd839d0a0ea9a2b9248a1287840bc601e774fb6b28f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9a0e1d5eb30194a4309588c383cc4e179804e88314b280e2d04c96069ebef867"
    sha256 cellar: :any,                 arm64_ventura:  "9f808a8325a153535d7b22da23d652929bfce526493dc0ee5a4505a971ae7b43"
    sha256 cellar: :any,                 arm64_monterey: "6d6326c365e861f65a1f13438ccb409600f2dc7783e8bfc42835f247e545d4c2"
    sha256 cellar: :any,                 sonoma:         "8e92431961fce081d8094362611f3550938938f3e8d7de7c369c691be9ef77c2"
    sha256 cellar: :any,                 ventura:        "c1f1f76069f4f73b50c02c7434e77f0eb22f16a92c2e7756101c41bd40ae989c"
    sha256 cellar: :any,                 monterey:       "4f2d247267535a9a8cd3eebf91891d3c0f555035533db9a40e32b03ca47c9e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c80410be8c65b37b135596873de64f7587068d32d0b8ba8ba91f4299f609e8ed"
  end

  depends_on "doxygen" => :build
  depends_on "pkg-config" => :test

  def install
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    flags = shell_output("pkg-config --libs --cflags libnet").chomp.split
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdint.h>
      #include <libnet.h>

      int main(int argc, const char *argv[])
      {
        printf("%s", libnet_version());
        return 0;
      }
    EOS

    system ENV.cc, "test.c", *flags, "-o", "test"
    assert_match version.to_s, shell_output(".test")
  end
end