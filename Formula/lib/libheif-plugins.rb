class LibheifPlugins < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://ghfast.top/https://github.com/strukturag/libheif/releases/download/v1.23.5/libheif-1.23.5.tar.gz"
  sha256 "fd9036064c4432f0550d15072ddf34956a248279ee9aeaff0fba3fa0f77d8f1a"
  license "LGPL-3.0-or-later"

  livecheck do
    formula "libheif"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7033a7cd8e7b70ab2616c1b262b2e67ab5448629042e187d57f91fbb6e4d71b8"
    sha256 cellar: :any, arm64_tahoe:       "de97d50796e01a54ad197456c6edec6a26b32e910f6150759b1d8e7f34a64c58"
    sha256 cellar: :any, arm64_sequoia:     "1170bf4cce7faab622460d055df5de6994e86d670d5929499e6c690f80cd267f"
    sha256 cellar: :any, arm64_linux:       "e0cba0a83c9bb88f1bcde1ddd8517ae94eca869a73b883aa2378358ff6ddbefe"
    sha256 cellar: :any, x86_64_linux:      "f5b01ff7577606fd2d5f0ac2275ad6fc04c1b6bdf7c0608bba2aeb9d15a2e390"
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

  deny_network_access!
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
    libheif_bin = formula_opt_bin("libheif")
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