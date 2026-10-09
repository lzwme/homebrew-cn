class H264bitstream < Formula
  desc "Library for reading and writing H264 video streams"
  homepage "https://h264bitstream.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/h264bitstream/h264bitstream/0.2.0/h264bitstream-0.2.0.tar.gz"
  sha256 "94912cb07ef67da762be9c580b325fd8957ad400793c9030f3fb6565c6d263a7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "c663a21f5399fb8b3f330a343fb39cf82b2dd308d263683493f0e27fc5959d70"
    sha256 cellar: :any,                 arm64_tahoe:       "77e29214581bbed1453a6aea582cafb5f4525634fca321e4ad503873722acabb"
    sha256 cellar: :any,                 arm64_sequoia:     "4616a724fcfbdc091a8be99a5746c3c1a20e9be058fd4acd09a3e4ac12ab7756"
    sha256 cellar: :any,                 arm64_sonoma:      "946ce648f0daf4e64a182e2f39811d0d78946a5150899dffe5984bb1926a88f2"
    sha256 cellar: :any,                 arm64_ventura:     "9fd917379072e27703bae053f19aefc1abbf328dfcf5857e6aa4192babe3fc48"
    sha256 cellar: :any,                 arm64_monterey:    "21fef413b7c8c4ae235dcdd1aba11a77553cd382f74d328c5958ba7e6ed47c39"
    sha256 cellar: :any,                 arm64_big_sur:     "86d9c15b08de87f85f791e45669241a1a27fefef2ddbccf6016642505e69c6e6"
    sha256 cellar: :any,                 sonoma:            "614b023114612bd3882c240f6a76ccae5b0fb4a10a8f79660e0c7cf4a6aa8931"
    sha256 cellar: :any,                 ventura:           "befe3309e1c2b4670bd77c741ac73abadcbb23fab0199422b61d901111fae7b3"
    sha256 cellar: :any,                 monterey:          "65af04578c1f21572695b045a268c8de1f3e8592dde3c407a2cc0c9e5aae797f"
    sha256 cellar: :any,                 big_sur:           "2ace75ebe5094b847024fb80a23a82bba3acfa7869399f3962c6910089ebc777"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fc3ca9983f5e3f12e4f0f602606d56aa96e40ecdc224dd27018b9e7d3220a42f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c79de8d86abcc4f3f95f8bd7a504116fe189546101cec66d52ab6295bf0bf376"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :test

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
    inreplace lib/"pkgconfig/libh264bitstream.pc", "${libdir}/libh264bitstream.la", "-lh264bitstream"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdint.h>
      #include <h264bitstream/h264_stream.h>

      int main(void) {
        uint8_t buf[] = {
          0x00, 0x00, 0x00, 0x01, 0x67, 0x64, 0x00, 0x1e, 0xac, 0xd9, 0x40, 0xa0,
          0x3d, 0xb0, 0x11, 0x00, 0x00, 0x03, 0x00, 0x01, 0x00, 0x00, 0x03, 0x00,
          0x32, 0x8f, 0x16, 0x2d, 0x96, 0x00, 0x00, 0x00, 0x01
        };
        int nal_start, nal_end;
        h264_stream_t* h = h264_new();
        if (find_nal_unit(buf, sizeof(buf), &nal_start, &nal_end) <= 0) return 1;
        read_nal_unit(h, &buf[nal_start], nal_end - nal_start);
        printf("type=%d profile=%d level=%d %dx%d\\n", h->nal->nal_unit_type,
               h->sps->profile_idc, h->sps->level_idc,
               (h->sps->pic_width_in_mbs_minus1 + 1) * 16,
               (h->sps->pic_height_in_map_units_minus1 + 1) * 16);
        h264_free(h);
        return 0;
      }
    C
    flags = shell_output("pkg-config --cflags --libs libh264bitstream").chomp.split
    system ENV.cc, "test.c", *flags, "-o", "test"
    assert_equal "type=7 profile=100 level=30 640x480", shell_output("./test").strip
  end
end