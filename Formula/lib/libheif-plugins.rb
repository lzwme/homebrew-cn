class LibheifPlugins < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://ghfast.top/https://github.com/strukturag/libheif/releases/download/v1.23.0/libheif-1.23.0.tar.gz"
  sha256 "4c9182b18897617182eed12ab5eb9f9d855b3aa3a736d6bdb31abc034ec7d393"
  license "LGPL-3.0-or-later"
  revision 3

  livecheck do
    formula "libheif"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9c9e0a4f02567cc8aaf18efca45bc3d13f776915a0d6a031db56cb217e0e45ae"
    sha256 cellar: :any, arm64_sequoia: "74ae7f4cba148bcd5ff09d4083af9189f13c47098ce1791490b198912e826e59"
    sha256 cellar: :any, arm64_sonoma:  "66816c3e87c240b57b5dc28cdc5e842d74aef3569c496282f8b3660a08db4cbc"
    sha256 cellar: :any, sonoma:        "d48fdc509203e6b11f28b06d6d4ec0109af8111d335b483661d77651ac12a912"
    sha256 cellar: :any, arm64_linux:   "0550c4b51464a98581b9dfa9d42273c57e078ea82243d2dac6d6b3a81cafa1f5"
    sha256 cellar: :any, x86_64_linux:  "96d8d9f3a0814730dd66d2f785421363a491fccb4b2ac3d112732558143cb376"
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
      -DCMAKE_INSTALL_RPATH=#{rpath(source: lib/"libheif", target: formula_opt_lib("libheif"))}
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