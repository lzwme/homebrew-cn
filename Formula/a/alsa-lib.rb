class AlsaLib < Formula
  desc "Provides audio and MIDI functionality to the Linux operating system"
  homepage "https://www.alsa-project.org/"
  url "https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.15.tar.bz2"
  sha256 "83770841585e766a60c99fd23f8c574c22643ae0cb1f2d20b793c3d84eb95a8d"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://www.alsa-project.org/files/pub/lib/"
    regex(/href=.*?alsa-lib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "ac65c08eb78d4473f6d13df1c623d532ed798c8e48b901a316fac2deb8efb358"
    sha256 x86_64_linux: "1c9a1edf73d46d29c31e36d23d23704922c87ea8951be942c65e5f6f9350a790"
  end

  depends_on :linux

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    prefix.install "aserver/COPYING" => "COPYING-aserver"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <alsa/asoundlib.h>
      int main(void)
      {
          snd_ctl_card_info_t *info;
          snd_ctl_card_info_alloca(&info);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lasound", "-o", "test"
    system "./test"
  end
end