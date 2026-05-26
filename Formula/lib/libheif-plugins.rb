class LibheifPlugins < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://ghfast.top/https://github.com/strukturag/libheif/releases/download/v1.22.2/libheif-1.22.2.tar.gz"
  sha256 "eea48e4841f83fbe51d029337ffd2d14512d0203015dad40b90213d872958af3"
  license "LGPL-3.0-or-later"

  livecheck do
    formula "libheif"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4897edd3bc1e959759c6276f2a3e4104b1bc550dbd76c9ca71d6edf6c8c7ce51"
    sha256 cellar: :any,                 arm64_sequoia: "0631f2c8e59746d8a77d2e8ee61db64ec44461c4d14da74391b6d49226a9725a"
    sha256 cellar: :any,                 arm64_sonoma:  "e7869456a11f12a001fc279a931e41ff73a86b1e005ab7c89fbd40b03aaa77c4"
    sha256 cellar: :any,                 sonoma:        "0451fda57be3f2c781e56ca16e86916b4dbe3be0c5a236b43e78cb3d7087e3cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd5ec134000b169c20ed2cb626de922615f76739fce297ebbb6ed112d194025d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e80006fcff8bd90b00f0db39123e7eb552f59007a01c2ff7ad9e11fd56fb1db8"
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