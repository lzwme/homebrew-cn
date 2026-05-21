class LibheifPlugins < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://ghfast.top/https://github.com/strukturag/libheif/releases/download/v1.22.0/libheif-1.22.0.tar.gz"
  sha256 "8bd20cfa3201997b8f63266cddfabea2e1481467d7f992e6a2595e0bec691fc2"
  license "LGPL-3.0-or-later"

  livecheck do
    formula "libheif"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22e51dde874edf10c40a6d5682d6979babef6e5a22ca1d84092dd374e947c3fe"
    sha256 cellar: :any,                 arm64_sequoia: "9f6c0cbf2a06f9bfb8200f745955475ad27db72cf9f602508f9f080801d03660"
    sha256 cellar: :any,                 arm64_sonoma:  "8cffa1f094f887be8e898251141d8207d0f31c1c0f463fb09a5a916e460c366c"
    sha256 cellar: :any,                 sonoma:        "efbe49a4f1614beaade5da665106144fadb8b4ce8f6a08dca1b8ce295ab34da8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edaf5d52b1e1ae096d2cffb827a6e4fdb47ef4b932665ad37daebe9f8ef88319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "203d4b37e3c60615d188f05e1cb58a51cfc57727c82c4650f088a3120fa99538"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "dav1d"
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "openjpeg"
  depends_on "openjph"
  depends_on "rav1e"
  depends_on "svt-av1"
  depends_on "x264"

  # Fix for missed common_utils.cc in OpenJPEG_DECODER plugin's sources, remove in next release
  patch do
    url "https://github.com/strukturag/libheif/commit/b5ccea15c1f62d6dc2301bd0551194f433e91217.patch?full_index=1"
    sha256 "b74848c61f41e076534511d7b42d9c72f9e9e9c7a3bc6dd1c104381681d7f3e9"
  end

  def install
    # Enabling plugins for "popular" formulae
    plugins = %w[
      DAV1D
      FFMPEG_DECODER
      JPEG_DECODER
      JPEG_ENCODER
      OpenJPEG_DECODER
      OpenJPEG_ENCODER
      OPENJPH_ENCODER
      RAV1E
      SvtEnc
      X264
    ]

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath(source: lib/"libheif", target: Formula["libheif"].opt_lib)}
      -DPLUGIN_DIRECTORY=#{HOMEBREW_PREFIX}/lib/libheif
      -DPLUGIN_INSTALL_DIRECTORY=#{lib}/libheif
      -DWITH_AOM_DECODER=OFF
      -DWITH_AOM_ENCODER=OFF
      -DWITH_EXAMPLES=OFF
      -DWITH_GDK_PIXBUF=OFF
      -DWITH_LIBDE265=OFF
      -DWITH_OpenH264_DECODER=OFF
      -DWITH_X265=OFF
    ] + plugins.flat_map { |plugin| ["-DWITH_#{plugin}=ON", "-DWITH_#{plugin}_PLUGIN=ON"] }

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build/libheif/plugins"
    system "cmake", "--install", "build/libheif/plugins"
  end

  test do
    libheif_bin = Formula["libheif"].bin
    decoders = shell_output("#{libheif_bin}/heif-dec --list-decoders")
    encoders = shell_output("#{libheif_bin}/heif-enc --list-encoders")

    %w[dav1d ffmpeg libjpeg-turbo openjpeg].each do |decoder|
      assert_match decoder, decoders
    end
    %w[libjpeg-turbo openjpeg openjph rav1e x264].each do |encoder|
      assert_match encoder, encoders
    end

    system libheif_bin/"heif-enc", test_fixtures("test.jpg"), "--htj2k", "--output", "test.hej2"
    assert_match "MIME type: image/hej2k", shell_output("#{libheif_bin}/heif-info test.hej2")
  end
end